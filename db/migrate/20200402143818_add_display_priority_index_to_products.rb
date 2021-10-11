class AddDisplayPriorityIndexToProducts < ActiveRecord::Migration[6.0]
  def change
    add_index :products, :display_priority
  end
end
