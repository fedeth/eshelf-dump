class AddPriceFieldToShopOrdersTable < ActiveRecord::Migration[6.0]
  def change
    add_column :shop_orders, :price, :bigint
  end
end
