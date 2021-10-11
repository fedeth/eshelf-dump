class ChangeQuantityAndStatusFieldsToProducts < ActiveRecord::Migration[6.0]
  def change
    Product.update_all(status: "active")
    add_column :products, :quantity, :bigint, :default => 1
    change_column :products, :status, :text, :null => false, :default => "active"
  end
end