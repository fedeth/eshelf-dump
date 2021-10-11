class UpdateTrigramsToProductsTable < ActiveRecord::Migration[6.0]
  def change
    add_index :products, :title, opclass: :gin_trgm_ops, using: :gin
  end
end
