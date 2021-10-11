class PageController < ApplicationController

  include ProductsHelper
  include ShopsHelper

  def index
    if current_user.present?
      # TODO: this is a test to check order/payment journey
      @product = build_product(Product.last)
    elsif current_shop.present?
      redirect_to "/shops/my_shop"
    end
  end

  def home
    @content = {}
    @content["action"] = params["action"]
    sample_products = Product.with_attached_main_image.take(8)
    @content["sample_products"] =  build_products(sample_products)
    

    if current_shop.present?
      redirect_to "/shops/my_shop" and return
    end

    if cookies.signed[:postcode].present?
      @content[:postcode] = cookies.signed[:postcode]
    end

    @content

  end
end