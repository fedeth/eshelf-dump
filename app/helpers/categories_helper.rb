module CategoriesHelper

  def build_categories()
    categories = {}
    # if current_shop.present? TODO: caching these values
      Category.all.with_attached_category_image.each do |category|
        categories[category.id] = {}
        categories[category.id][:id] = category.id
        categories[category.id][:name] = category.name
        categories[category.id][:title] = category.title
        categories[category.id][:description] = category.description
        categories[category.id][:parent_id] = category.parent_id
        categories[category.id][:category_image] = may_add_category_image(category.category_image)
      end
    categories
  end

  # When a variant is requested, system check whether it exists in S3 bucket.
  # This operation requires about 300 - 1200ms for each variant and this is unaceptable.
  # We are wainting for Rails 6.1 that will be fix this issue.
  # https://github.com/rails/rails/pull/37901
  def may_add_category_image(main_image)
    if main_image.present?
      if main_image.variable?
        # return main_image.variant(resize_to_limit: [1280, 1280]).processed.service_url rescue nil
        return main_image.service_url rescue nil
      else
        # TODO: log this exception
        return nil
      end
    else
      nil
    end
  end


end
