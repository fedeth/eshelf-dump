class StaticPagesController < PageController

  PATH = File.join(Rails.root, "resources", "static_html_contents")

  def about_us
    @content = {}
    @content
  end

  def sell_with_us
    @content = {}
    @content
  end

  def faqs
    faqs = [
      ["Shopping on eShelf", File.read(File.join(PATH, "shop_on_eshelf.html")).to_json],
      ["Payment", File.read(File.join(PATH, "payment.html")).to_json],
      ["Order & Shipping", File.read(File.join(PATH, "orders_and_shipping.html")).to_json],
      ["Returns & Refund", File.read(File.join(PATH, "returns_and_refund.html")).to_json],
    ]
    @content = { faqs: faqs }
    @content
  end

  def orders_and_shipping
    @content = {}
    @content
  end

  def payment_and_pricing
    @content = {}
    @content
  end

  def returns_and_refunds
    @content = {}
    @content
  end

  def affiliate_programme
    @content = {}
    @content
  end

  def contact_us
    @content = {}
    @content
  end

  def terms_and_conditions
    @content = {}
    @content
  end

  def privacy_policy
    @content = {}
    @content
  end

  def cookie_policy
    @content = {}
    @content
  end

end