class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.text :full_name
      t.text :address_line
      t.text :opt_address_line
      t.text :phone_number
      t.text :postcode
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
