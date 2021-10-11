class CreateShopOrderProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :shop_order_products do |t|
      t.references :shop_order, foreign_key: true
      t.references :product, foreign_key: true
      t.integer :quantity
      t.timestamps
    end
  end
end
