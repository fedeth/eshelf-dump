class UserPromocode < ApplicationRecord
  belongs_to :promocode
  belongs_to :user
end