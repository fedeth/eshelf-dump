class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|

      t.string :name
      t.string :description
      t.string :aux
      t.integer :category_id
      t.integer :quantity
      t.string :status
      t.integer :price
      t.integer :lock_version, default: 0
      t.references :shop, foreign_key: true

      t.timestamps
    end

    add_index :products, :status
    add_index :products, :category_id

  end
end
