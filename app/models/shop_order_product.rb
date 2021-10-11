class ShopOrderProduct < ApplicationRecord
	belongs_to :shop_order
	belongs_to :product
end