module PromocodesHelper
  
  def check_promocode_validity(code, errors = [])
    promocode = Promocode.find_by_name(code)
    if promocode.present?
      if DateTime.now >= promocode.valid_from && DateTime.now <= promocode.valid_to
        user_promocodes = UserPromocode.where(promocode_id: promocode.id, user_id: current_user.id)
        if user_promocodes.count > 0 && !promocode.repeatable
          errors.push("Promocode already used")
        end
      else
        errors.push("This promocode is expired")
      end
    else
      errors.push("Invalid promocode")
    end

    !errors.present?
  end
  
end