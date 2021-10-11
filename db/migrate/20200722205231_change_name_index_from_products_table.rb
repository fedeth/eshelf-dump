class ChangeNameIndexFromProductsTable < ActiveRecord::Migration[6.0]
  def change
    remove_index :products, :name
    add_index :products, :name, unique: true
  end
end
