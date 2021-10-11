module ProductsHelper
  include EventsLogUtils

  # DEFAULT GET PRODUCTS PARAMS
  DEFAULT_GET_PRODUCTS_PARAMS = {
    page_number: 1, # number of current result page
    search_text: nil, # search text
    # category_ids: [], # ids of the categories used to filter products - all child categories will be taken too
    category_names: [], # names of the categories used to filter products - all child categories will be taken too
    sort_by: "", # sort logic can be: by ascendent price ("price_asc"), descendent price ("price_desc"), last inserted ("created_at_desc") or distance of the shop ("distance")
    price_range: [], # price range, an array of two integers where the first is the minimum price and the second is the maximum (example: [10,200])
    page_size: 12, # how many products should be included in one page
    position: {}, # user position as object {latitude: Float, longitude: Float}, useful only for sort_by: "distance"
  }

  # The get_products query construction works like this:
  # 1. Take products loading also shops and main images. NB: "includes" is not sufficient for shops, an inner join is required.
  # 2. Add "where" clauses on price range and category ids, order is not rilevant though.
  # 3. Add "order by" clause, depending on params - for sorting by distance a starting position is required (see params description for details).
  # 4. Add full text search statements. NB: this statements must be after all ordering stuffs, ordering logic will be overwritten by full text search ranking otherwise.
  # 5. Take only required products with respect to specified page number and page size (through "offset" and "limit" statements).
  # Thanks to initial :includes + :joins statements, shop info are already available and is sufficient to map them into useful objects
  def get_products(parameters)
    params = merge_params_with_defaults(parameters)

    # log_event(params, "get_products_start", 1)

    # products retrieving
    searched_products = Product.includes(:shop).where(status: "active").joins(:shop).with_attached_main_image

    # price range
    if params[:price_range].present?
      min_price = params[:price_range][0].present? ? params[:price_range][0].to_i : 1
      max_price = params[:price_range][1].present? ? params[:price_range][1].to_i : 1000000
      searched_products = searched_products.where(price: (min_price*100)..(max_price*100)) 
    end

   
    # category filtering
    if params[:category_names].present?
      parent_categories = Category.includes(:sub_categories).where(parent_id: nil, name: params[:category_names])
      params[:category_names] -= parent_categories.map{|parent| parent.name}
      parent_to_children_category_names = {}
      parent_categories.each do |parent|
        children_names = parent.sub_categories.map{|sub| sub.name}
        parent_to_children_category_names[parent.name] = (children_names & params[:category_names]) | children_names
      end
      params[:category_names] += parent_to_children_category_names.map{|key, value| value}.flatten
      category_ids = Category.where(name: params[:category_names]).pluck(:id)
      searched_products = searched_products.where(category_id: category_ids)
    end
    

    # sorting
    if params[:sort_by] == "price_asc"
      searched_products = searched_products.order(price: :asc)
    end
    if params[:sort_by] == "price_desc"
      searched_products = searched_products.order(price: :desc)
    end
    if params[:sort_by] == "created_at_desc"
      searched_products = searched_products.order(created_at: :desc)
    end
    # Deprecated
    # if params[:sort_by] == "distance"
    #   position = JSON.parse(params[:position])
    #   if position.present? && position["latitude"].present? && position["longitude"].present?
    #     searched_products = searched_products.select("*, SQRT(POW(69.1 * (shops.latitude - #{position["latitude"].to_f}), 2) + POW(69.1 * (#{position["longitude"].to_f} - shops.longitude) * COS(shops.latitude / 57.3), 2)) AS distance").order("distance")
    #   else
    #     raise ArgumentError.new("Search by distance requires the user position as parameter :position => {\"latitude\": Float, \"longitude\": Float}")
    #   end
    # end

    # search_text
    if params[:search_text].present?
      searched_products = searched_products.search_full_text(params[:search_text])
    end

    # pages management
    params[:page_number] = params[:page_number].to_i
    products_number = searched_products.count
    number_of_pages = products_number.to_i / params[:page_size].to_i
    number_of_pages += 1 if products_number.to_i % params[:page_size].to_i > 0
    offset = (params[:page_number].to_i - 1) * params[:page_size].to_i
    searched_products = searched_products.offset(offset).limit(params[:page_size].to_i)

    # shops info retrieving
    shops = searched_products.map{|product| [product.shop.id, product.shop.as_json]}.uniq.to_h
    
    # log_event(params, "get_products_end", 1)

    # result
    {
      shops: shops,
      number_of_pages: number_of_pages,
      products: build_products_array(searched_products),
      search_params: params.filter{|k,v| parameters.keys.map{|k| k.to_sym}.include?(k)}
    }
  end

  # Try to deprecate this method in favour of build_products_array
  def build_products(shop_products)
    products = {}
      shop_products.each do |product|
        products[product.id] = build_product(product)
      end
    products
  end

  def build_products_array(products, options = {})
    products.map do |product|
      build_product(product, options)
    end
  end

  def build_products_for_basket(basket, products)
    # TODO: remove quantity from product model
    products.map do |product|
      prd = build_product(product)
      prd[:quantity] = basket[prd[:id]][:quantity]
      prd
    end
  end

  def build_product_for_order(products, product_id_to_quantity)
    products.map do |product|
      prd = build_product(product)
      prd[:quantity] = product_id_to_quantity[product.id]
      prd
    end
  end

  def build_product(product, options = {})

    _product = {
      id: product.id,
      lock_version: product.lock_version,
      name: product.name,
      title: product.title,
      brand: product.brand,
      category_id: product.category_id,
      shop_id: product.shop_id || nil,
      description: product.description,
      price: product.price,
      quantity: product.quantity,
      tech_spec: (product.specs.split(";") rescue nil),
      product_security_key: (Digest::SHA256.hexdigest("#{product.id}#{ENV['PRODUCT_SALT']}")),
    }

    unless options[:skip_images_loading]
      #Temporary fix:
      image_or_thumbnail = may_add_product_main_image(product.main_image)
      _product[:main_image] = image_or_thumbnail
      _product[:thumbnail] = image_or_thumbnail
    end

    _product
  end


  # When a variant is requested, system check whether it exists in S3 bucket.
  # This operation requires about 300 - 1200ms for each variant and this is unaceptable.
  # We are wainting for Rails 6.1 that will be fix this issue.
  # https://github.com/rails/rails/pull/37901
  def may_add_product_main_image(main_image)
    if main_image.present?
      if main_image.variable?
        # return main_image.variant(resize_to_limit: [1280, 1280]).processed.service_url rescue nil
        return main_image.service_url rescue nil
      else
        # TODO: log this exception
        return nil
      end
    else
      nil
    end
  end

  # When a variant is requested, system check whether it exists in S3 bucket.
  # This operation requires about 300 - 1200ms for each variant and this is unaceptable.
  # We are wainting for Rails 6.1 that will be fix this issue.
  # https://github.com/rails/rails/pull/37901
  def may_add_product_thumbnail(main_image)
    if main_image.present?
      if main_image.variable?
        return main_image.variant(resize_to_limit: [600, 600]).processed.service_url rescue nil
      else
        # TODO: log this exception
        return nil
      end
    else
      nil
    end
  end

  private def merge_params_with_defaults(params)
    get_products_params = {}
    DEFAULT_GET_PRODUCTS_PARAMS.each do |key, value|
      get_products_params[key] = params[key] || value
    end
    get_products_params
  end

  def validate_product(params, errors, config = {})
    validation_to_perform = Set[:title, :category_id, :brand, :price, :description, :specs, :keywords, :file, :quantity]
    if config[:except].present? && config[:except].is_a?(Array)
      config[:except].each{|skipping_validation| validation_to_perform.delete(skipping_validation)}
    end
    
    if errors.blank? && validation_to_perform.include?(:title)
      if params["title"].blank?
        errors.push("Product title can't be blank")
      end
    end

    if errors.blank? && validation_to_perform.include?(:category_id)
      if params["category_id"].blank?
        errors.push("Choose a valid category")
      end
      if errors.blank? && Category.find(params["category_id"].to_i).blank?
        errors.push("Selected category not found")
      end
    end

    if errors.blank? && validation_to_perform.include?(:brand)
      if params["brand"].blank?
        errors.push("Brand can't be blank")
      end
    end

    if errors.blank? &&validation_to_perform.include?(:price)
      if params["price"].blank?
        errors.push("Brand can't be blank")
      end
    end

    if errors.blank? && validation_to_perform.include?(:description)
      if params["description"].blank?
        errors.push("Description can't be blank")
      end
    end

    if errors.blank? && validation_to_perform.include?(:specs)
      if params["specs"].blank?
        errors.push("Specifications can't be blank")
      end
    end

    if errors.blank? && validation_to_perform.include?(:keywords)
    end

    if errors.blank? && validation_to_perform.include?(:file)
      if params["file"].blank?
        errors.push("Error occurs during picture upload")
      else
        permitted_mime_types = Set["image/png", "image/jpeg"]
        if permitted_mime_types.include?(params["file"].content_type)
          if (params["file"].size / 1024) > 512
            errors.push("Picture dimensions exceed 500kb")
          end
        else
          errors.push("Unsupported file format")
        end
      end
    end

    if errors.blank? && validation_to_perform.include?(:quantity)
      if params["quantity"].blank?
        errors.push("Quantity can't be blank")
      end
    end

    errors
  end

end
 