class CategoriesController < PageController
  include GeocodeHelper
  include ProductsHelper

  def show
    # if current_user_location.nil?
    #   flash[:alert] = "Please enter a valid postcode or enable geolocation on your device"
    #   redirect_to root_path and return
    # end

    number_of_product_per_each_category = 10
    category_ids = Category.where(parent_id: nil).pluck(:id)

    first_n_products_per_each_category_query = "SELECT id FROM (SELECT *, row_number()
    over (Partition BY category_id) AS row_number FROM products) tmp
    WHERE row_number <= #{number_of_product_per_each_category} AND category_id IN (#{category_ids.join(',')}) "
    first_n_product_ids = ActiveRecord::Base.connection.exec_query(first_n_products_per_each_category_query)
    # NOTE: add with_attached_* to avoid n+1 queries
    first_n_products = Product.with_attached_main_image.where(id: first_n_product_ids.rows.flatten)

    # WARNING
    # This solution returns an active record object, but is ~ 180 times slower!
    # first_n_products = Product.with_attached_main_image.select("prd1.*")
    #   .from("products prd1")
    #   .joins("LEFT JOIN products AS prd2 ON prd1.category_id = prd2.category_id AND prd1.id <= prd2.id")
    #   .group("prd1.category_id, prd1.id")
    #   .having("count(*) <= #{number_of_product_per_each_category}")
    #   .order("prd1.category_id")
    #   .where("prd1.category_id IN (#{category_ids.join(',')})")

    products_by_category_id = {}
    first_n_products.each do |product|
      products_by_category_id[product["category_id"]] ||= []
      products_by_category_id[product["category_id"]].push(build_product(product))
    end

    @content = {products_by_category_id: products_by_category_id}

  end
end