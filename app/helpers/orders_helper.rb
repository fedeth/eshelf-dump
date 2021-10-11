module OrdersHelper
  include ErrorHandling
  include VirtualBasketsHelper

  def order_params
    params.permit(:product_id, :quantity, :product_security_key, :delivery_info, :promocode, :format)
  end

  def create_order_request_is_valid?(order_params, basket, error_messages)
    return basket_is_valid?(basket, error_messages) && delivery_info_is_valid?(order_params, error_messages)
  end  

  def delivery_info_is_valid?(order_params, error_messages)
    is_valid = error_messages.blank?
    delivery_info = JSON.parse(order_params[:delivery_info]) rescue nil
    if delivery_info.present?
      ["firstName", "lastName", "addressLine1", "postcode", "phoneNumber"].each do |field|
        if is_valid && delivery_info[field].blank?
          error_messages.push("Delivery info #{field} is not present")
          is_valid = false
        end
      end
      is_valid = delivery_postcode_is_valid?(delivery_info["postcode"], error_messages) if is_valid
    else
      is_valid = false
      error_messages.push("Delivery info not present")
    end
    is_valid
  end


  def delivery_postcode_is_valid?(postcode, error_messages)
    # TODO, perform a validation
    true
  end

  def build_orders(orders)
    built_orders = []
    orders.each do |order|
      built_orders.push(build_order(order))
    end
    built_orders
  end

  def build_order(order_model)
    order = {
      order_id: order_model.id,
      created_at: order_model.created_at,
      status: order_model.status,
      price: order_model.payment.payment_amount
    }
    order
  end

  def get_oreder_products_id_to_quantity(order)
    product_id_to_ordered_quantity = {}
    order.shop_orders.each do |shop_order|
      shop_order.shop_order_products.each do |shop_order_product|
        product_id_to_ordered_quantity[shop_order_product.product_id] = shop_order_product.quantity
      end
    end
    product_id_to_ordered_quantity
  end

  def update_order_after_payment(payment_intent)
    ActiveRecord::Base.transaction do
      payment = Payment.find_by_payment_intent_id(payment_intent[:id])
      order = payment.order
      order.update(status: "Paid")
      payment.update(
        aux: {payment_intent: payment_intent},
        status: payment_intent["status"]
      )
    end
  end

end
