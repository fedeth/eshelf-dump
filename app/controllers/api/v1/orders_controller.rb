class Api::V1::OrdersController < ApplicationController

  include OrdersHelper
  include ProductsHelper
  include VirtualBasketsHelper
  include PromocodesHelper

  def create
    error_messages = []
    if current_user.present?
      basket = get_basket_from_cookies(cookies.signed[:basket])
      if create_order_request_is_valid?(order_params, basket, error_messages)
        order_id = nil
        shop_id_to_product_info = {}
        shop_id_to_shop_order_net_price = {}
        order_net_price = 0
        delivery_info = JSON.parse(order_params[:delivery_info])
        promocode_name = order_params[:promocode].downcase.strip
        
        Product.where(id: basket.keys).each do |product|
          shop_id_to_shop_order_net_price[product.shop_id] ||= 0
          shop_id_to_shop_order_net_price[product.shop_id] += product.price * basket[product.id][:quantity]
          shop_id_to_product_info[product.shop_id] ||= {}
          shop_id_to_product_info[product.shop_id][product.id] = {quantity: basket[product.id][:quantity]}
          order_net_price += (product.price * basket[product.id][:quantity])
        end

        ActiveRecord::Base.transaction do

          promocode_info = {id: nil, value: 0}
          if promocode_name.present? && check_promocode_validity(promocode_name)
            promocode = Promocode.find_by_name(promocode_name)
            UserPromocode.create(user_id: current_user.id, promocode_id: promocode.id)
            promocode_info[:id] = promocode.id
            promocode_info[:value] = promocode.value
          end

          order = Order.create(user_id: current_user.id, aux: {delivery_info: delivery_info, promocode_info: promocode_info})
          shop_id_to_product_info.keys.each do |shop_id|
            shop_order = ShopOrder.create(
              order_id: order.id,
              shop_id: shop_id,
              price: (shop_id_to_shop_order_net_price[shop_id] + STANDARD_SHIPPING_COST).to_i
            )
            shop_id_to_product_info[shop_id].each do |product_id, product_info|
              ShopOrderProduct.create(shop_order_id: shop_order.id, product_id: product_id, quantity: product_info[:quantity])
            end
          end
          payment_intent = Stripe::PaymentIntent.create({
            amount: (order_net_price + (STANDARD_SHIPPING_COST * shop_id_to_product_info.count) - promocode_info[:value]).to_i,
            currency: 'gbp',
          })
          Payment.create(
            order_id: order.id,
            payment_intent_id: payment_intent["id"],
            payment_amount: payment_intent["amount"],
            aux: {},
            status: payment_intent["status"]
          )
          order_id = order.id
          cookies.delete(:basket)
        end
      end
    else
      error_messages.push("Users must be logged in")
    end
    if error_messages.blank?
      respond_to do |format|
        format.json { render json: {order_id: order_id}}
      end
    else
      respond_with_error('create_order_action', nil, error_messages)
    end
  end

  def verify_stripe_payment
    response = {}
    payment_intent_response = JSON.parse(params["payment_intent"])
    payment_intent = Stripe::PaymentIntent.retrieve(payment_intent_response["id"])
    payment = Payment.where(payment_intent_id: payment_intent.id).eager_load(:order => [[:shop_orders => [:shop_order_products => :product]], :user]).first rescue nil
    if payment.present?
      payment.update_attribute(:status, payment_intent["status"])
      if payment_intent.status == "requires_payment_method"
        if payment.order.status != "NEW"
          payment.order.update_attribute(:status, "NEW")
          payment.order.shop_orders.each do |shop_order|
            shop_order.update_attribute(:status, "NEW")
          end
        end
      elsif payment_intent.status == "succeeded"
        if payment.order.status != "PAID"
          payment.order.update_attribute(:status, "PAID")
          payment.order.shop_orders.each do |shop_order|
            shop_order.update_attribute(:status, "PAID")
          end
        end

        products = []
        product_id_to_ordered_quantity = {}
        payment.order.shop_orders.each do |shop_order|
          shop_order.shop_order_products.each do |shop_order_product|
            product_id_to_ordered_quantity[shop_order_product.product_id] = shop_order_product.quantity
            products.push(shop_order_product.product)
          end
        end
    
        ordered_products = build_product_for_order(products, product_id_to_ordered_quantity)

        ApplicationMailer.mail_customer_order_submitted(payment.order.user.email, payment.order, ordered_products, request.base_url).deliver_later
        
        shop_id_to_ordered_products = {}
        ordered_products.each do |product| 
          shop_id_to_ordered_products[product[:shop_id]] ||= []
          shop_id_to_ordered_products[product[:shop_id]].push(product)
        end

        payment.order.shop_orders.each do |shop_order|
          ordered_products_from_shop = shop_id_to_ordered_products[shop_order.shop_id]
          ApplicationMailer.mail_seller_order_recived(shop_order, ordered_products_from_shop, request.base_url).deliver_later
        end

        payment.order.aux["send_analytics"] = true
        payment.order.save
        
        response[:success] = true
      end
    else
      response[:error] = "Payment not found"
    end

    respond_to do |format|
      format.json { render json: response }
    end
  end

end