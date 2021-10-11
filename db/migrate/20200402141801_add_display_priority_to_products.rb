class AddDisplayPriorityToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :display_priority, :bigint
  end
end
