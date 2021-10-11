class CreateSubmissions < ActiveRecord::Migration[6.0]
  def change
    create_table :submissions do |t|
      t.json :form_fields
      t.bigint :user_id
      t.string :email

      t.timestamps
    end
    add_index :submissions, :user_id
    add_foreign_key :submissions, :users
  end
end
