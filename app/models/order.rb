class Order < ApplicationRecord
  has_one :payment, dependent: :destroy
  belongs_to :user
  has_many :shop_orders, dependent: :destroy
end
