class ChangeShopInitialStatus < ActiveRecord::Migration[6.0]
  def change
    change_column :shops, :status, :text, :null => false, :default => "incomplete"
  end
end
