class OrdersController < PageController
  include OrdersHelper
  include PaymentsHelper
  include ShopsHelper
  include VirtualBasketsHelper

  def new
    @content = {}
    basket = get_basket_from_cookies(cookies.signed[:basket])
    if basket.present?
      products = Product.where(id: basket.keys)
      @content[:number_of_shops] = products.pluck(:shop_id).uniq.count
      @content[:products] = build_products_for_basket(basket, products)
    else
      redirect_to "/shopping_cart" and return
    end
    @content
  end

  def pay
    @content = {}
    order = Order.where(id: params["order_id"], user_id: current_user.id).first
    product_id_to_ordered_quantity = {}
    if order.present?
      payment_intent = Stripe::PaymentIntent.retrieve(order.payment.payment_intent_id)
      if payment_intent.present? && payment_intent.status == "requires_payment_method"
        if order.payment.status != "requires_payment_method"
          order.payment.update_attribute(:status, payment_intent["status"])
        end
        if order.status != "NEW"
          order.update_attribute(:status, "NEW")
          order.shop_orders.each do |shop_order|
            shop_order.update_attribute(:status, "NEW")
          end
        end
        @content[:delivery_info] = order.aux["delivery_info"]
        @content[:promocode_info] = order.aux["promocode_info"] if order.aux["promocode_info"].present?
        @content[:order_info] = {
          id: order.id,
          status: order.status,
          payment_intent_id: order.payment.payment_intent_id
        }
        @content[:client_secret] = payment_intent.client_secret
        @content[:public_key] = ENV['STRIPE_PUBLIC_KEY']
        product_id_to_ordered_quantity = get_oreder_products_id_to_quantity(order)
        products = Product.where(id: product_id_to_ordered_quantity.keys)
        @content[:products] =  build_product_for_order(products, product_id_to_ordered_quantity)
        @content[:number_of_shops] = products.pluck(:shop_id).uniq.count
      else
        redirect_to "/" and return
      end
    else
      redirect_to "/" and return
    end
    @content
  end

  def show
    @content = {}
    product_id_to_ordered_quantity = {}
    order = Order.where(id: params["order_id"], user_id: current_user.id).first
   
    if order.present?
      payment_intent = Stripe::PaymentIntent.retrieve(order.payment.payment_intent_id)
      if payment_intent.status == "succeeded"
        
        # These lines are needed for FB events / analytics
        if order.aux["send_analytics"] == true
          @content[:send_analytics] = true
          order.aux.delete("send_analytics")
          order.save
        else
          if params["completed"].blank?
            redirect_to action: "show", completed: "true"
          end
        end

        if order.payment.status != "succeeded"
          order.payment.update_attribute(:status, payment_intent["status"])
        end

        if order.status != "PAID"
          order.update_attribute(:status, "PAID")
          order.shop_orders.each do |shop_order|
            shop_order.update_attribute(:status, "PAID")
          end
        end
        @content[:delivery_info] = order.aux["delivery_info"]
        @content[:promocode_info] = order.aux["promocode_info"] if order.aux["promocode_info"].present?
        @content[:order_info] = {
          id: order.id,
          status: order.status,
          payment_intent_id: order.payment.payment_intent_id
        }
        product_id_to_ordered_quantity = get_oreder_products_id_to_quantity(order)
        products = Product.where(id: product_id_to_ordered_quantity.keys)

        @content[:products] =  build_product_for_order(products, product_id_to_ordered_quantity)
        @content[:number_of_shops] = products.pluck(:shop_id).uniq.count
      else
        redirect_to "/" and return
      end
    else
      redirect_to "/" and return
    end
    @content
  end

  def order_confirmation
    @content = {}
    if order_is_valid?(params["payment_intent_id"], params["order_id"])
      # TODO: why this line doesn't perform joins?
      order = Order.includes(:product).includes(:payment).find(params["order_id"].to_i)
      @content[:product] = build_product(order.product)
      @content[:order] = build_order(order)
      @content[:shop] = build_shop(order.product.shop)
    end
    @content
  end

end