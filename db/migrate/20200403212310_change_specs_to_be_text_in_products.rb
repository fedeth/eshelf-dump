class ChangeSpecsToBeTextInProducts < ActiveRecord::Migration[6.0]
  def change
    change_column :products, :specs, :text
  end
end
