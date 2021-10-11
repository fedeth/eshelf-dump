class CreateOpeningHours < ActiveRecord::Migration[6.0]
  def change
    create_table :opening_hours do |t|
      t.integer :week_day
      t.time :open_time
      t.time :close_time
      t.integer :lock_version, default: 0
      t.references :shop, foreign_key: true
    end
  end
end