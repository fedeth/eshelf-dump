class UpdateFieldsAndIndexFromOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :quantity
    remove_column :orders, :collect_code
    remove_column :orders, :product_id
    remove_column :orders, :shop_id
    remove_column :orders, :delivery_date
    change_column_default :orders, :status, "NEW"
  end
end
