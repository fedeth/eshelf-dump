class Shop < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_one_attached :shop_avatar
  has_many :products, dependent: :destroy
  has_many :shop_orders, dependent: :destroy
  has_many :opening_hours, dependent: :destroy


  # reverse_geocoded_by :latitude, :longitude
  # after_validation :reverse_geocode

  # Deprecated
  # before_validation :assign_coordinates

  validates :address, :city, :postcode, :presence => true, :if => Proc.new { |a| a.status != 'pending' }

  private
    # def assign_coordinates
    #   if self.status != "initialized"
    #     if (self.latitude.nil? || self.longitude.nil?) && (self.address.present? && self.city.present?)
    #       available_places = Geocoder.search("#{self.address}, #{self.city}")
    #       if available_places.length > 0
    #         location = available_places.first
    #         self.latitude = location.latitude
    #         self.longitude = location.longitude
    #       end
    #     end
    #   end
    # end
end
