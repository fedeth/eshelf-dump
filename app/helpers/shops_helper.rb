module ShopsHelper

  include GeocodeHelper

  def get_current_shop_opening_hours()
    if current_shop.present?
      opening_hours = OpeningHour.where(shop_id: current_shop.id)
      opening_hours.map { |opening_hour| opening_hour.as_json }
    else
      nil
    end
  end

  def build_shops(shops)
    # coords = current_user_location
    shops_info = {}
    # if current_shop.present? unecessay check
      shops.each do |shop|
        shops_info[shop.id] = build_shop(shop)
      end
    # end
    shops_info
  end

  def build_shop(shop, coords = nil)
    shop_model = { id: shop.id }
    shop_model[:address] = shop.address
    shop_model[:city] = shop.city
    shop_model[:latitude] = shop.latitude
    shop_model[:longitude] = shop.longitude
    shop_model[:postcode] = shop.postcode
    shop_model[:distance] = shop.distance_to([coords["latitude"], coords["longitude"]]) if coords.present?
    shop_model[:status] = shop.status
    shop_model[:trading_name] = shop.trading_name
    shop_model[:shop_avatar] = shop.shop_avatar.present? ? url_for(shop.shop_avatar) : nil
    shop_model[:opening_hours] = get_current_shop_opening_hours()
    shop_model
  end
 
end
