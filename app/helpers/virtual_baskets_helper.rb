module VirtualBasketsHelper

  def build_cart_info()
    info = {}
    basket = get_basket_from_cookies(cookies.signed[:basket])
    if basket.is_a?(Hash) && basket.count > 0
      info[:products_types_quantity] = basket.count
    end
    info
  end

  def basket_is_valid?(basket, error_messages)
    is_valid = error_messages.blank?
    if basket.keys.all? {|i| i.is_a?(Integer)}
      products_id = basket.keys
      if Product.where(id: products_id).count != basket.keys.count
        is_valid = false
        error_messages.push("basket products doens't mach")
      end
    else
      is_valid = false
      error_messages.push("invalid product key in the virtual basket")
    end
    is_valid
  end

  def get_basket_from_cookies(c_basket)
    h_basket = {}
    if c_basket.present?
      basket = JSON.parse(c_basket)
      basket.each do |id, info|
        h_basket[id.to_i] ||= {}
        info.each do |key, value|
          h_basket[id.to_i][key.parameterize.underscore.to_sym] = value.to_i
        end
      end
    end
    h_basket
  end
end