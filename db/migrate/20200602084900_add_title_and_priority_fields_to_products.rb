class AddTitleAndPriorityFieldsToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :title, :text
    add_column :products, :priority, :bigint
    add_column :products, :title_tsv, :tsvector
    add_index :products, :priority
  end
end
