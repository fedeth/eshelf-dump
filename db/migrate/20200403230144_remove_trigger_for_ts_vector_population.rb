class RemoveTriggerForTsVectorPopulation < ActiveRecord::Migration[6.0]
  def change
    execute <<-SQL
    DROP TRIGGER specsvectorupdate ON products CASCADE;
    SQL
  end
end
