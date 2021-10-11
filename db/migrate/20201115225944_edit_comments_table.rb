class EditCommentsTable < ActiveRecord::Migration[6.0]
  def change
    remove_index :comments, [:user_id, :content_id]
    remove_reference :comments, :content, index: true
    add_column :comments, :content_id, :text, :null => false
    add_index :comments, :content_id
  end
end
