class AddFieldsToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :address, :text
    add_column :shops, :phone_number, :bigint
    add_column :shops, :city, :text
    add_column :shops, :postcode, :text
    add_column :shops, :status, :text, :null => false, :default=> "initialized"
    add_column :shops, :company_number, :text
    add_column :shops, :legal_name, :text
    add_column :shops, :trading_name, :text
    add_column :shops, :contact_person_role, :text
    add_column :shops, :contact_person_first_name, :text
    add_column :shops, :contact_person_last_name, :text
    add_column :shops, :latitude, :float
    add_column :shops, :longitude, :float
    add_column :shops, :aux, :json, default: {}

    add_index :shops, [:latitude, :longitude]
  end
end