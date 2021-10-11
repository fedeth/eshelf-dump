class Api::V1::ShopsController < ApplicationController

  def update_shop_info
    current_shop.update_attributes(permitted_params)
    response = build_shop_info.to_json

    respond_to do |format|
      format.json { render json: response }
    end
  end

  def update_shop_avatar
    # TODO: check params["file"] to prevent malicious intents
    update_file = current_shop.update(shop_avatar: params["file"])

    if update_file
      response = {success: update_file, attachment_url: url_for(current_shop.shop_avatar)}
    end

    respond_to do |format|
      format.json { render json: response }
    end
  end

  private
    def permitted_params
      params.reject{|_, v| v.blank?}.permit(:address, :city, :company_number, :contact_person_first_name,
        :contact_person_last_name, :contact_person_role, :phone_number, :postcode, :trading_name)
    end

end