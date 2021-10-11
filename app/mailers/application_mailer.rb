class ApplicationMailer < ActionMailer::Base
  include ApplicationHelper
  include OrdersHelper
  include ProductsHelper

  EMAIL_FROM = "eShelf <service@#{ENV['AWS_SES_ACCOUNT'] || 'eshelf.co.uk'}>"
  EMAIL_SALES = ENV['SALES_EMAIL_ADDRESS']

  def mail_customer_order_submitted(recipients, order, ordered_products, base_url)
    subject = "Order #00#{order.id} submitted"
    @order = order
    @ordered_products = ordered_products
    @delivery_info = order.aux["delivery_info"]
    @product_price_amount = @ordered_products.reduce(0){|tot_price, prd| tot_price += prd[:price] * prd[:quantity]} / 100.0
    @shipping_cost = @order.shop_orders.count * (STANDARD_SHIPPING_COST / 100.0)
    @promocode_discount = order.aux["promocode_info"].present? ? (order.aux["promocode_info"]["value"] / 100.0) : 0.0
    @paid_amount = (@shipping_cost + @product_price_amount - @promocode_discount)
    @base_url = base_url
    mail(to: recipients, subject: subject, from: EMAIL_FROM) 
  end

  def mail_seller_order_recived(shop_order, ordered_products_from_shop, base_url)
    recipients = shop_order.shop.email
    @user = shop_order.order.user
    @order = shop_order.order
    @ordered_products = ordered_products_from_shop
    @delivery_info = shop_order.order.aux["delivery_info"]
    @product_price_amount = @ordered_products.reduce(0){|tot_price, prd| tot_price += prd[:price] * prd[:quantity]} / 100.0
    @base_url = base_url
    subject = "Order #00#{shop_order.order.id} recived"
    mail(to: recipients, subject: subject, from: EMAIL_FROM)
  end

  def mail_seller_join_us(form_data)
    @formData = form_data
    subject = "Join with us form, TODO: find an object for this email."
    mail(to: EMAIL_SALES, subject: subject, from: EMAIL_FROM)
  end

  def test_email(mailto, text, from = EMAIL_FROM)
    @text = text
    subject = "Email test"
    mail(to: mailto, subject: subject, from: from)
  end

end 
