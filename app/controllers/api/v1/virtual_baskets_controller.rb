class Api::V1::VirtualBasketsController < ApplicationController
  include VirtualBasketsHelper

  def add_product
    product_id = basket_params[:id].to_i
    product_quantity = basket_params[:quantity].to_i
    basket = get_basket_from_cookies(cookies.signed[:basket])
    if basket[product_id].present?
      basket[product_id][:quantity] += product_quantity
    else
      basket[product_id] = {quantity: product_quantity}
    end
    cookies.signed[:basket] = basket.to_json
    respond_to do |format|
      format.json { render json: {status: :ok, action: "added"} }
    end
  end

  def remove_product
    product_id = basket_params[:id].to_i
    basket = get_basket_from_cookies(cookies.signed[:basket])
    if basket[product_id].present?
      basket.delete(product_id)
    end
    cookies.signed[:basket] = basket.to_json
    respond_to do |format|
      format.json { render json: {status: :ok, action: "removed"} }
    end
  end

  def get_products
  end

  def edit_product
  end

  private
    def basket_params
      params.permit(:id, :quantity, :format)
    end
  
end