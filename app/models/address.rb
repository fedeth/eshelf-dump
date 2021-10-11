class Address < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: 'shop_id'
end