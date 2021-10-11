class CreateUserPromocodes < ActiveRecord::Migration[6.0]
  def change
    create_table :user_promocodes do |t|
      t.references :user, foreign_key: true, null: false
      t.references :promocode, foreign_key: true, null: false
      t.timestamps
    end
  end
end
