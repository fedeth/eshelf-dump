class CollectionsController < PageController
  include ProductsHelper
  
  def show_all
    @content = {}
    @content
  end

  def show
    @content = {}
    products = Product.take(8)
    @content[:products] = build_products_array(products)
    @content
  end

end