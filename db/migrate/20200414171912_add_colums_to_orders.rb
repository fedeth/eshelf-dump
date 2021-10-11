class AddColumsToOrders < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :shop, index: true
    add_foreign_key :orders, :shops
  end
end
