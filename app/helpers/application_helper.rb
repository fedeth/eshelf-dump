module ApplicationHelper

  def is_true?(obj)
    return obj.to_s.downcase == "true" rescue false
  end

  def build_user_info
    if current_user.present?
      user = current_user
      user_model = { id: user.id }
      user_model[:first_name] = user.first_name
      user_model[:last_name] = user.last_name
      user_model[:email] = user.email
      user_model
    else
      { anonymous: true }
    end
  end

  def build_shop_info
    if current_shop.present?
      shop = current_shop
      shop_model = { id: shop.id }
      shop_model[:address] = shop.address
      shop_model[:aux] = shop.aux
      shop_model[:city] = shop.city
      shop_model[:company_number] = shop.company_number
      shop_model[:contact_person_first_name] = shop.contact_person_first_name
      shop_model[:contact_person_last_name] = shop.contact_person_last_name
      shop_model[:contact_person_role] = shop.contact_person_role
      shop_model[:email] = shop.email
      shop_model[:latitude] = shop.latitude
      shop_model[:legal_name] = shop.legal_name
      shop_model[:longitude] = shop.longitude
      shop_model[:phone_number] = shop.phone_number
      shop_model[:postcode] = shop.postcode
      shop_model[:status] = shop.status
      shop_model[:trading_name] = shop.trading_name
      shop_model[:shop_avatar] = shop.shop_avatar.present? ? url_for(shop.shop_avatar) : nil
      # shop_model[:opening_hours] = get_current_shop_opening_hours
      shop_model
    else
      { anonymous: true }
    end
  end
  
end
