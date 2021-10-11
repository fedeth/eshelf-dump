class AddLabelToLogEvents < ActiveRecord::Migration[6.0]
  def change
  	add_column :log_events, :label, :text
  end
end
