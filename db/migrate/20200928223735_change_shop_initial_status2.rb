class ChangeShopInitialStatus2 < ActiveRecord::Migration[6.0]
  def change
    change_column :shops, :status, :text, :null => false, :default => "pending"
  end
end
