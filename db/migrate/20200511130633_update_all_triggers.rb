class UpdateAllTriggers < ActiveRecord::Migration[6.0]
  def change
    execute <<-SQL
      DROP TRIGGER nametsvectorupdate ON products CASCADE;
      DROP TRIGGER descriptiontsvectorupdate ON products CASCADE;
      DROP TRIGGER specstsvectorupdate ON products CASCADE;
      DROP TRIGGER keywordstsvectorupdate ON products CASCADE;
      DROP TRIGGER brandtsvectorupdate ON products CASCADE;

      CREATE TRIGGER nametsvectorupdate BEFORE INSERT OR UPDATE
  		ON products FOR EACH ROW EXECUTE PROCEDURE
  		tsvector_update_trigger(name_tsv, 'pg_catalog.english_stem', name);

		  CREATE TRIGGER descriptiontsvectorupdate BEFORE INSERT OR UPDATE
			ON products FOR EACH ROW EXECUTE PROCEDURE
			tsvector_update_trigger(description_tsv, 'pg_catalog.english_stem', description);

    	CREATE TRIGGER brandtsvectorupdate BEFORE INSERT OR UPDATE
  		ON products FOR EACH ROW EXECUTE PROCEDURE
  		tsvector_update_trigger(brand_tsv, 'pg_catalog.english_stem', brand);

		  CREATE TRIGGER keywordstsvectorupdate BEFORE INSERT OR UPDATE
			ON products FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(keywords_tsv, 'pg_catalog.english_stem', keywords);

      CREATE TRIGGER specstsvectorupdate BEFORE INSERT OR UPDATE
			ON products FOR EACH ROW EXECUTE PROCEDURE
			tsvector_update_trigger(specs_tsv, 'pg_catalog.english_stem', specs);
		SQL
  end
end
