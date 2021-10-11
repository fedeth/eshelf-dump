class AddTsVectorColumnsToProducts < ActiveRecord::Migration[6.0]
  def change
  	add_column :products, :name_tsv, :tsvector
  	add_column :products, :description_tsv, :tsvector
  end
end
