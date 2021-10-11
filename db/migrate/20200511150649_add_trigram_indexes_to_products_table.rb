class AddTrigramIndexesToProductsTable < ActiveRecord::Migration[6.0]
  def change
    add_index :products, :name, opclass: :gin_trgm_ops, using: :gin
    add_index :products, :description, opclass: :gin_trgm_ops, using: :gin
    add_index :products, :keywords, opclass: :gin_trgm_ops, using: :gin
    add_index :products, :specs, opclass: :gin_trgm_ops, using: :gin
    add_index :products, :brand, opclass: :gin_trgm_ops, using: :gin
  end
end