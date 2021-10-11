class CreatePostcodes < ActiveRecord::Migration[6.0]
  def change
    create_table :postcodes, {:id => false} do |t|
      t.float :latitude
      t.float :longitude
      t.string :postcode
    end

    add_index :postcodes, [:latitude, :longitude]
    execute "ALTER TABLE postcodes ADD PRIMARY KEY (postcode);"
    add_foreign_key :shops, :postcodes, column: :postcode, primary_key: :postcode
  end
end
