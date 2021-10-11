module ImportHelper
  require 'csv'
  require 'uri'

  def update_product_quantity(file_path)
    logger = Logger.new(File.join(Rails.root, "log", "update_product_quantity.log"))
    logger.info "START update_product_quantity rake"
    csv_reading_options = {col_sep: "\t", headers: true, quote_char: "\x00"}
    csv_product_names_to_quantity = {}
    CSV.foreach(file_path, csv_reading_options).with_index do |csv_product, index|
      if csv_product["title"].present? && csv_product["stock"].present?
        csv_product_names_to_quantity[csv_product["title"].parameterize.gsub("-","_")] = csv_product["stock"].to_i
      else
        logger.warn "missing product title info at line #{index + 2}" if csv_product["title"].blank?
        logger.warn "missing product stock info at line #{index + 2}" if csv_product["stock"].blank?
      end
    end
    products = Product.where(name: csv_product_names_to_quantity.keys)
    products.each do |product|
      if product.update({quantity: csv_product_names_to_quantity[product.name]})
        logger.info "Update product #{product.name} quantity to #{csv_product_names_to_quantity[product.name]}"
      else
        logger.error "Fail to update #{product.name} product"
      end
    end
    logger.info "END update_product_quantity rake"
  end

  def import_initial_products(file_path, shop_id, limit = nil)
    # ["name", "brand", "category", "generic_description", "tech_spec", "search_keywords", "stock", "price", "picture"]
    logger = Logger.new(File.join(Rails.root, "log", "import_products.log"))
    category_name_to_id = build_category_name_to_id()
    csv_reading_options = {col_sep: "\t", headers: true, quote_char: "\x00"}
    CSV.foreach(file_path, csv_reading_options).with_index do |csv_product, index|
      if limit.blank? || index < limit 
        add_product(csv_product, category_name_to_id, shop_id, logger)
      end
    end
  end

  def add_product(csv_product, category_name_to_id, shop_id, logger)
    product_to_edit = Product.find_by_name(csv_product["title"].parameterize.gsub("-","_"))
    if product_to_edit.present?
      product = product_to_edit
      logger.info "Already exist #{csv_product['title']}"
    else
      product = Product.new(name: csv_product["title"].parameterize.gsub("-","_"))
      logger.info "Add product #{csv_product['title'].parameterize.gsub("-","_")}"
    end
    product.category_id = category_name_to_id[csv_product["category"].parameterize.gsub("-","_")]
    product.title = csv_product['title']
    product.shop_id = shop_id
    product.brand = csv_product["brand"]
    product.price = (csv_product["price"].to_f * 100).to_i
    product.description = csv_product["generic_description"]
    product.specs = csv_product["tech_spec"]
    product.keywords = csv_product["search_keywords"].present? ? csv_product["search_keywords"].gsub(",","") : csv_product["search_keywords"]
    img_file =  URI.open(csv_product['picture']) rescue nil
    if img_file.present?
      img_uri = URI.parse(csv_product['picture'])
      if img_uri.present?
        img_file_name = File.basename(img_uri.path)
        product.main_image.attach(io: img_file, filename: img_file_name)
      else
        logger.warn "Unable to open img url for #{csv_product["title"].parameterize.gsub("-","_")}"
        logger.info "URL: #{csv_product['picture']}"
      end
    else
      logger.warn "Missing image for #{csv_product["title"].parameterize.gsub("-","_")}"
    end
    product.save
    product
  end

  def build_category_name_to_id()
    category_name_to_id = {}
    Category.all.each do |category|
      category_name_to_id[category.name] = category.id
    end
    category_name_to_id
  end

  def import_initial_categories(file_path, limit = nil)
    top_level_categories = {}

    @logger = Logger.new(File.join(Rails.root, "log", "import_categories.log"))
    csv_reading_options = {col_sep: "\t", headers: true}
    @logger.info("Categories import script start...")

    CSV.foreach(file_path, csv_reading_options).with_index do |csv_category, index|
      if csv_category["parent_category"] == "-"
        top_level_categories[csv_category["title"].parameterize.gsub("-","_")] = add_category(csv_category)
      end
    end

    CSV.foreach(file_path, csv_reading_options).with_index do |csv_category, index|
      if csv_category["parent_category"] != "-"
        add_category(csv_category, top_level_categories[csv_category["parent_category"].parameterize.gsub("-","_")].id)
      end
    end
  end

  def add_category(csv_category, parent_category_id = nil)
    category_to_remove = Category.find_by_name(csv_category["title"].parameterize.gsub("-","_"))
    category_to_remove.destroy if category_to_remove.present?
    category = Category.new(name: csv_category["title"].parameterize.gsub("-","_"), title: csv_category["title"])
    category.parent_id = parent_category_id if parent_category_id.present?
    img_file =  URI.open(csv_category['picture']) rescue nil
    if img_file.present?
      img_uri = URI.parse(csv_category['picture'])
      img_file_name = File.basename(img_uri.path)
      category.category_image.attach(io: img_file, filename: img_file_name)
    end
    category.save
    category
  end

  def check_categories_and_products_before_import(category_file_path, products_file_path)
    @logger = Logger.new(File.join(Rails.root, "log", "check_categories_and_products.log"))
    @logger.info("Check script starts...")
    csv_reading_options = {col_sep: "\t", headers: true, quote_char: "\x00"}

    top_level_categories = {}
    CSV.foreach(category_file_path, csv_reading_options).with_index do |csv_category, index|
      if csv_category["parent_category"] == "-"
        @logger.info("Top level category found: #{csv_category["title"]}")
        category_name = csv_category["title"].parameterize.gsub("-","_")
        @logger.info("Top level category name: #{category_name}")
        top_level_categories[category_name] = {}
        img_file =  URI.open(csv_category['picture']) rescue nil
        if img_file.blank?
          @logger.warn("Missing picture for category: #{category_name}")
        end
      end
    end

    CSV.foreach(category_file_path, csv_reading_options).with_index do |csv_category, index|
      if csv_category["parent_category"] != "-"
        @logger.info("Sub-category found: #{csv_category["title"]}")
        category_name = csv_category["title"].parameterize.gsub("-","_")
        @logger.info("Sub-category name: #{category_name}")
        if top_level_categories[csv_category["parent_category"].parameterize.gsub("-","_")].is_a?(Hash)
          @logger.info("#{category_name} is child of #{csv_category["parent_category"].parameterize.gsub("-","_")}")
          top_level_categories[csv_category["parent_category"].parameterize.gsub("-","_")][category_name] = true
        end
      end
    end

    number_of_categories = top_level_categories.count
    number_of_sub_categories = 0
    
    top_level_categories.each do |k,v|
      number_of_sub_categories += v.count
    end

    @logger.info("Number of top level categories: #{number_of_categories}")
    @logger.info("Number of sub-categories: #{number_of_sub_categories}")
    @logger.info("Total number of categories: #{number_of_sub_categories + number_of_categories}")

    @logger.info("Processing products")

    CSV.foreach(products_file_path, csv_reading_options).with_index do |csv_product, index|
      @logger.info("Product found: #{csv_product["title"]}")
      product_name = csv_product["title"].parameterize.gsub("-","_")
      @logger.info("Product name: #{product_name}")

      cat_found = false
      top_level_categories.each do |k,v|
        if v[csv_product["category"].parameterize.gsub("-","_")].present?
          cat_found = true
          break
        end
      end

      if !cat_found
        @logger.warn("Missing category for #{product_name}, category name: #{csv_product["category"].parameterize.gsub("-","_")}")
      end
      
      if csv_product["brand"].blank?
        @logger.warn("Missing brand for product: #{product_name}")
      end

      if csv_product["generic_description"].blank?
        @logger.warn("Missing generic description for product: #{product_name}")
      end

      if csv_product["tech_spec"].blank?
        @logger.warn("Missing tech spec for product: #{product_name}")
      end

      if csv_product["search_keywords"].blank?
        @logger.warn("Missing keywords for product: #{product_name}")
      end
      
      img_file =  URI.open(csv_product['picture']) rescue nil
      if img_file.present?
        img_uri = URI.parse(csv_product['picture'])
        if img_uri.blank?
          @logger.warn "Unable to open img url for #{product_name}"
          @logger.info "URL: #{csv_product['picture']}"
        end
      else
        @logger.warn "Missing picture for #{csv_product["name"]}"
      end
    end

  end
end