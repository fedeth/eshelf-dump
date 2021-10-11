class AddLabelToSubmissions < ActiveRecord::Migration[6.0]
  def change
  	add_column :submissions, :label, :text
  end
end
