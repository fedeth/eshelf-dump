class VirtualBasketsController < PageController
  include VirtualBasketsHelper
  include ProductsHelper

  def checkout
    @content = {}
    basket = get_basket_from_cookies(cookies.signed[:basket])
    if basket.present?
      products = Product.where(id: basket.keys)
      @content[:products] = build_products_for_basket(basket, products)
      @content[:number_of_shops] = products.pluck(:shop_id).uniq.count
    end

    @content
  end
end