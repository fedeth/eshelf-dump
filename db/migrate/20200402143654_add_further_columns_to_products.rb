class AddFurtherColumnsToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :brand, :text
    add_column :products, :keywords, :text
    add_column :products, :specs, :json, default: {}
    add_column :products, :brand_tsv, :tsvector
    add_column :products, :specs_tsv, :tsvector
  	add_column :products, :keywords_tsv, :tsvector
  end
end
