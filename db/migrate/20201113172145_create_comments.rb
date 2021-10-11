class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :text
      t.json :aux
      t.boolean :approved, default: true
      t.references :content, null: false
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end
    add_index :comments, [:user_id, :content_id], unique: true
  end
end
