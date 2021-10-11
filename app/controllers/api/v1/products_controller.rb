class Api::V1::ProductsController < ApplicationController
  include ProductsHelper
  include ErrorHandling

  def create_product
    errors = []
    product_saved = false
    if current_shop.present?
      validate_product(product_params, errors)
      if errors.blank?
        product = Product.new()
        product.shop_id = current_shop.id
        product.name = product_params["title"].parameterize.gsub("-","_")
        product.category_id = product_params["category_id"].to_i
        product.title = product_params["title"]
        product.brand = product_params["brand"]
        product.price = (product_params["price"].to_f * 100).to_i
        product.description = product_params["description"]
        product.specs = product_params["specs"]
        product.keywords =  product_params["keywords"].present? ? product_params["keywords"].gsub(",","") : ""
        product.main_image.attach(product_params["file"])
        product.quantity = product_params["quantity"].to_i
        product_saved = product.save
      end
    end

    if !product_saved && (product.errors.messages.present? rescue false)
      product.errors.messages.each do |field, err_messages|
        err_messages.each do |err_msg|
          errors.push("Product #{field.to_s} #{err_msg}")
        end
      end
    end
    success = errors.blank? && product_saved
    
    if success 
      flash.notice = "The product <b>#{product.title}<\/b> has been successfully added.".html_safe
    end

    respond_to do |format|
      format.json { render json: {success: success, errors: errors} }
    end
  end

  def update_product
    errors = []
    product_saved = false
    if current_shop.present?
      validation_to_skip = []
      if product_params["file"].blank?
        validation_to_skip.push(:file)
      end
      validate_product(product_params, errors, {except: validation_to_skip})
      if errors.blank?
        product = Product.where(id: product_params["id"].to_i, shop_id: current_shop.id, status: 'active').first
        if product.present?
          product.category_id = product_params["category_id"].to_i
          product.title = product_params["title"]
          product.brand = product_params["brand"]
          product.price = (product_params["price"].to_f * 100).to_i
          product.description = product_params["description"]
          product.specs = product_params["specs"]
          product.keywords =  product_params["keywords"].present? ? product_params["keywords"].gsub(",","") : ""
          product.main_image.attach(product_params["file"]) unless validation_to_skip.include?(:file)
          product.quantity = product_params["quantity"].to_i
          product_saved = product.save
        else
          erros.push("product not found")
        end
      end
    end

    success = errors.blank? && product_saved

    if success 
      flash.notice = "The product <a href=\"#{request.base_url}/shops/my_shop/products/edit/#{product.id}\"><b>#{product.title}<\/b><\/a> has been successfully updated.".html_safe
    end

    respond_to do |format|
      format.json { render json: {success: success, errors: errors} }
    end
  end

  def delete_product
    success = false
    product = Product.where(id: product_params["id"].to_i, shop_id: current_shop.id).first
    if product.present?
      success = product.update(status: "deleted")
      flash.alert = "The product <b>#{product.title}<\/b> has been deleted.".html_safe if success
    end

    respond_to do |format|
      format.json { render json: {success: success} }
    end
  end

  def get_products_api
    begin
      result = get_products(search_permitted_params)
      respond_to do |format|
        format.json { render json: result }
      end
    rescue => _
      respond_with_error('invalid_resource', result)
    end
  end

  def get_products_suggestions
    search_text = params[:search_text].downcase.strip if params[:search_text]
    max_results_number = params[:limit] || 10
    begin
      searched_products = Product.where(status:'active').search_full_text(search_text).limit(max_results_number).select(:title)
      respond_to do |format|
        format.json { render json: { suggestions: searched_products.map{ |p| p.title }.uniq } }
      end
    rescue => _
      respond_with_error('invalid_resource', searched_products)
    end
  end

  private
    def edit_permitted_params
      params.reject{|_, v| v.blank?}.permit(:category_id, :quantity)
    end

    def search_permitted_params
      params.reject{|_, v| v.blank?}.permit(:txt, :search_text, :page_size, :page_number, :sort_by, :position, :format, :price_range => [], :category_ids => [], :category_names => [])
    end

    def product_params
      params.reject{|_, v| v.blank?}.permit(:id ,:title, :category_id, :brand, :price, :description, :specs, :keywords, :file, :format, :quantity)
    end

end
