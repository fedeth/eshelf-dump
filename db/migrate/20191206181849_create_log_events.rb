class CreateLogEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :log_events do |t|
      t.text :session_id
      t.integer :pid
      t.string :request_uri
      t.time :timestamp
      t.text :level
      t.integer :user_id
      t.json :data
      t.boolean :synced
    end
  end
end
