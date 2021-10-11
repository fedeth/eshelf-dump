class CreateTriggersForTsVectorsPopulation < ActiveRecord::Migration[6.0]
  def change
    execute <<-SQL
    	CREATE TRIGGER nametsvectorupdate BEFORE INSERT OR UPDATE
  		ON products FOR EACH ROW EXECUTE PROCEDURE
  		tsvector_update_trigger(name_tsv, 'pg_catalog.simple', name);

		  CREATE TRIGGER descriptiontsvectorupdate BEFORE INSERT OR UPDATE
			ON products FOR EACH ROW EXECUTE PROCEDURE
			tsvector_update_trigger(description_tsv, 'pg_catalog.simple', description);
		SQL
  end
end
