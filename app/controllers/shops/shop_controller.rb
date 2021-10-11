class Shops::ShopController < PageController
  include ProductsHelper
  include OrdersHelper
  include ErrorHandling

  before_action :check_shop_status
  
  def registration_pending
    if current_shop.status != "pending"
      redirect_to root_path and return
    end
  end

  def complete_registration
    # TODO: in the shop is confirmed,  redirect to shop's root
  end

  def details

  end

  def order_details
    shop_order = ShopOrder.where(shop_id: current_shop.id, order_id: params["order_id"]).eager_load(:shop_order_products => [:product], :order => [:user]).first
    delivery_info = shop_order.order.aux["delivery_info"]
    user_info = {
      # first_name: shop_order.order.user.first_name,
      # last_name: shop_order.order.user.first_name,
      email: shop_order.order.user.email
    }
    products = []
    shop_order.products.each do |shop_order_product|
     _product = build_product(shop_order_product.product)
     _product[:quantity] = shop_order_product.quantity
      products.push(_product)
    end
    @content = {products: products, user_info: user_info, delivery_info: delivery_info, order_id: params["order_id"].to_i}
    @content
  end

  def show_orders
    @content = {orders: []}
    shop_orders = ShopOrder.where(shop_id: current_shop.id, status: "PAID").order(created_at: :desc).eager_load(:order => [:user])
    shop_orders.each do |shop_order|
      @content[:orders].push({
        id: shop_order.order_id,
        date: shop_order.updated_at,
        user_info: {
          # first_name: shop_order.order.user.first_name,
          # last_name: shop_order.order.user.first_name,
          email: shop_order.order.user.email
        },
        delivery_info: shop_order.order.aux["delivery_info"],
        status: shop_order.status,
        price: shop_order.price
      })
    end
    @content
  end

  def show_products
    shop_products = current_shop.products.where(status: 'active').order(updated_at: :desc).with_attached_main_image
    @products = build_products_array(shop_products, {skip_images_loading: shop_products.count >= 20})
    @products
  end

  def new_product
    @content = {}
    @content
  end

  def edit_product
    #TODO rename => show_product
    @content = {}
    product = Product.where(shop_id: current_shop.id, id: params["product_id"].to_i, status: 'active').first or (not_found and return)
    @content["current_product_data"] = {
      id: product.id,
      title: product.title,
      parent_category_id: product.category.parent_id,
      category_id: product.category_id,
      brand: product.brand,
      price: (product.price.to_f / 100).round(2),
      description: product.description,
      specs: product.specs,
      keywords: product.keywords.split(" ").join(", "),
      image_link: product.main_image.service_url,
      quantity: product.quantity
    }
    @content
  end

  def orders
    @content = {}
    orders = Order.includes(:product).includes(:payment).where(products: {shop_id: current_shop.id})
    @content[:orders] = build_orders(orders)
    @content
  end

  def opening_date_and_times
  end

  private

  def check_shop_status
    if current_shop.present?
      case current_shop.status 
      when 'pending'
        redirect_to '/shops/registration_pending' and return if action_name != "registration_pending"
      when 'incomplete'
        redirect_to '/shops/complete_registration' and return if action_name != "complete_registration"
      end
    end
  end
  

end
