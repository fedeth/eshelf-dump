class CreateFurtherTriggersForTsVectorPopulation < ActiveRecord::Migration[6.0]
  def change
    execute <<-SQL
    	CREATE TRIGGER brandtsvectorupdate BEFORE INSERT OR UPDATE
  		ON products FOR EACH ROW EXECUTE PROCEDURE
  		tsvector_update_trigger(brand_tsv, 'pg_catalog.simple', brand);

		  CREATE TRIGGER keywordstsvectorupdate BEFORE INSERT OR UPDATE
			ON products FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(keywords_tsv, 'pg_catalog.simple', keywords);

      CREATE TRIGGER specsvectorupdate BEFORE INSERT OR UPDATE
			ON products FOR EACH ROW EXECUTE PROCEDURE
			tsvector_update_trigger(specs_tsv, 'pg_catalog.simple', specs);
		SQL
  end
end
