class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.integer :quantity
      t.string :collect_code
      t.string :status, default: "Pending"
      t.references :user, foreign_key: true
      t.references :product, foreign_key: true
      t.json :aux, default: {}
      t.timestamps
    end

    add_index :orders, :status
    add_index :orders, :collect_code

  end
end
