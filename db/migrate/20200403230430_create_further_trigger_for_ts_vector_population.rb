class CreateFurtherTriggerForTsVectorPopulation < ActiveRecord::Migration[6.0]
  def change
    execute <<-SQL
      CREATE TRIGGER specstsvectorupdate BEFORE INSERT OR UPDATE
			ON products FOR EACH ROW EXECUTE PROCEDURE
			tsvector_update_trigger(specs_tsv, 'pg_catalog.simple', specs);
		SQL
  end
end
