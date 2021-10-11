class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.string :payment_intent_id, null: false
      t.string :payment_unit, default: "cents"
      t.integer :payment_amount
      t.string :status
      t.json :aux, default: {}
      t.references :order, foreign_key: true
      t.timestamps
    end

    add_index :payments, :payment_intent_id, unique: true

  end
end
