class ShopOrder < ApplicationRecord
  has_many :shop_order_products, dependent: :destroy
  alias_attribute :products, :shop_order_products
  belongs_to :order
  belongs_to :shop
end
