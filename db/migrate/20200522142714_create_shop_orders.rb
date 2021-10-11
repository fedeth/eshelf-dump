class CreateShopOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :shop_orders do |t|
      t.references :order, foreign_key: true
      t.references :shop, foreign_key: true
      t.string :status, default: "NEW"
      t.timestamps
    end
  end
end
