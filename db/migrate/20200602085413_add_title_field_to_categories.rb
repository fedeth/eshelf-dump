class AddTitleFieldToCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :title, :text
  end
end
