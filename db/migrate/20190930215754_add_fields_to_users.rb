class AddFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :text
    add_column :users, :last_name, :text
    add_column :users, :birth_date, :date
    add_column :users, :phone_number, :bigint
    add_column :users, :postcode, :text
    add_column :users, :aux, :json, default: {}
  end
end



