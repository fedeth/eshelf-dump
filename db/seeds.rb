# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

# USERS

require 'faker'
include PostcodesHelper
include ImportHelper


if Order.count > 0
  Order.destroy_all
end

if Product.count > 0
  Product.destroy_all
end

if User.count > 0
  User.destroy_all
end

if OpeningHour.count > 0
  OpeningHour.destroy_all
end

if Shop.count > 0
  Shop.destroy_all
end

if Postcode.count < 10000
  ActiveRecord::Base.connection.execute("TRUNCATE postcodes CASCADE")
  import_postcodes_into_db()
end

if Category.count > 0
  Category.destroy_all
end

# users = []
# u = User.new(email: "giornifederico+000@gmail.com", first_name: "Federico", last_name: "Giorni",
#   phone_number: 3331234567, postcode:"W8 6LP", password: "fedeshelf")
# u.skip_confirmation!
# u.save(validate: false)
# users.push(u)


# SHOPS
shops = []
s = Shop.new(email: "sales@eshelf.co.uk", address:"High street, 1", phone_number: 3274234567,
  contact_person_last_name: "Ambrowsi", contact_person_first_name: "Riccardo", company_number: "921562790", status: "active",
 postcode: "SW1A 0AA", contact_person_role: "Manager", password: "goeshelf2020", trading_name: "eShelf Shop",
 latitude: Postcode.find("SW1A 0AA").latitude, longitude: Postcode.find("SW1A 0AA").longitude)
s.skip_confirmation!
s.save(validate: false)
shops.push(s)


# OPENING HOURS
opening_hours = []
t1 = Time.parse('09:30')
t2 = Time.parse('12:30')
t3 = Time.parse('15:30')
t4 = Time.parse('19:30')
h = OpeningHour.new(week_day: 2, open_time: t1, close_time: t2, shop_id: shops[0].id)
h.save
opening_hours.push(h)
h = OpeningHour.new(week_day: 2, open_time: t3, close_time: t4, shop_id: shops[0].id)
h.save
opening_hours.push(h)

# CATEGORIES
path = File.join(Rails.root, "resources", "eshelf_categories.tsv")
if File.exist? path
  import_initial_categories(path)
end

# Is it correct to fill "name" with the name that users will see and "description" with a description of the category?
# c = Category.new(name: "Domestic Appliances", description: "Every kind of domestic appliances you'd like to have in your house")
# c.save
# categories.push(c)

# c = Category.new(name: "Information Technology", description: "IT things, like smartphones and laptops")
# c.save
# categories.push(c)

# c = Category.new(name: "Smartphones", description: "Every kind of smartphone,from samsung to iphone", parent_id: categories[1].id)
# c.save
# categories.push(c)

# c = Category.new(name: "Tablets", description: "Every kind of tablet,from samsung to ipad", parent_id: categories[1].id)
# c.save
# categories.push(c)

# c = Category.new(name: "Fruits", description: "The best fruits of London!")
# c.save
# categories.push(c)

# c = Category.new(name: "Test category 1", description: "Test category 1 desc")
# c.save
# categories.push(c)

# c = Category.new(name: "Test category 2", description: "Test category 2 desc")
# c.save
# categories.push(c)


# PRODUCTS

products = []
path = File.join(Rails.root, "resources", "eshelf_products.tsv")
if File.exist? path
  import_initial_products(path, s.id)
end

# p = Product.new(name: "Samsung Galaxy S10 plus", description: "The most powerful smartphone designed by Samsung",
#   shop_id: shops[0].id, category_id: categories[1].id, quantity: 8, price: Faker::Commerce.price)
# p.main_image.attach(io: File.open('seeds_img/galaxy_s10_plus.jpg'), filename: "galaxy_s10_plus.jpg", content_type: "image/jpg")
# p.save
# products.push(p)

# p = Product.new(name: "Banana", description: "Yellow bananas",
#   shop_id: shops[0].id, category_id: categories[2].id, quantity: 12, price: Faker::Commerce.price)
# p.main_image.attach(io: File.open('seeds_img/banana.jpg'), filename: "banana.jpg", content_type: "image/jpg")
# p.save
# products.push(p)

# p = Product.new(name: "Coconut", description: "Fresh coconuts",
#   shop_id: shops[0].id, category_id: categories[2].id, quantity: 7, price: Faker::Commerce.price)
# p.main_image.attach(io: File.open('seeds_img/coconut.jpg'), filename: "coconut.jpg", content_type: "image/jpg")
# p.save
# products.push(p)

# p = Product.new(name: "Apple", description: "Juicy apples", shop_id: shops[0].id, category_id: categories[2].id, quantity: 99, price: Faker::Commerce.price)
# p.main_image.attach(io: File.open('seeds_img/apple.jpg'), filename: "apple.jpg", content_type: "image/jpg")
# p.save
# products.push(p)

# p = Product.new(name: "Strawberry", description: "Sweet strawberries",
#   shop_id: shops[0].id, category_id: categories[2].id, quantity: 2, price: Faker::Commerce.price)
# p.main_image.attach(io: File.open('seeds_img/strawberry.jpg'), filename: "strawberry.jpg", content_type: "image/jpg")
# p.save
# products.push(p)

# massive_products = []
# i = 0
# placeholder_img = File.open('seeds_img/placeholder-img.jpg');
# seed_blob = nil
# while i < 500
# 	p = Product.new(name: Faker::Commerce.product_name,description: Faker::TvShows::BojackHorseman.quote,shop_id: shops[i%5].id,category_id: categories[i%5].id,quantity: rand(0..5),price: Faker::Commerce.price * 100)
#   if seed_blob.present?
#     p.main_image.attach(seed_blob)
#   else
#     p.main_image.attach(io: placeholder_img, filename: "placeholder-img.jpg", content_type: "image/jpg")
#   end
#   massive_products.push(p)
# 	i = i+1
#   p.save
#   if seed_blob.nil?
#     seed_blob = p.main_image.blob
#   end
#end
