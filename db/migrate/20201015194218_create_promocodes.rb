class CreatePromocodes < ActiveRecord::Migration[6.0]
  def change
    create_table :promocodes do |t|
      t.text :name, null: false
      t.integer :value, null: false
      t.datetime :valid_from , null: false
      t.datetime :valid_to, null: false
      t.boolean :repeatable, default: false
      t.timestamps
    end

    add_index :promocodes, :name, unique: true

  end
end
