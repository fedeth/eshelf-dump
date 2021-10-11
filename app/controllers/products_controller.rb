class ProductsController < PageController

  include GeocodeHelper
  include ProductsHelper

  def show_product
    @content = {}
    product = Product.includes(:shop).with_attached_main_image.find_by_name(params["product_name"])
    if product.present?
      @content[:product] = build_product(product)
    end
    @content
  end

  def search
    @content = {}
    search_results = get_products(search_permitted_params)
    @page_model[:search_params] = search_results[:search_params]
    @page_model[:search_results] = search_results.except(:search_params)
    @content
  end

  private def search_permitted_params
    params.reject{|_, v| v.blank?}.permit(:txt, :search_text, :page_size, :page_number, :sort_by, :position, :format, :price_range => [], :category_ids => [], :category_names => [])
  end

end