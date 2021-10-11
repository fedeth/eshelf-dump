class AddColumnDeliveryDateToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :delivery_date, :datetime
    add_index :orders, :delivery_date
  end
end
