class UpdateAllProductsTriggers < ActiveRecord::Migration[6.0]
  def change
    execute <<-SQL
      DROP TRIGGER nametsvectorupdate ON products CASCADE;
      DROP TRIGGER descriptiontsvectorupdate ON products CASCADE;
      DROP TRIGGER specstsvectorupdate ON products CASCADE;
      DROP TRIGGER keywordstsvectorupdate ON products CASCADE;
      DROP TRIGGER brandtsvectorupdate ON products CASCADE;

      CREATE TRIGGER titletsvectorupdate BEFORE INSERT OR UPDATE
  		ON products FOR EACH ROW EXECUTE PROCEDURE
  		tsvector_update_trigger(title_tsv, 'pg_catalog.simple', title);

		  CREATE TRIGGER descriptiontsvectorupdate BEFORE INSERT OR UPDATE
			ON products FOR EACH ROW EXECUTE PROCEDURE
			tsvector_update_trigger(description_tsv, 'pg_catalog.simple', description);

    	CREATE TRIGGER brandtsvectorupdate BEFORE INSERT OR UPDATE
  		ON products FOR EACH ROW EXECUTE PROCEDURE
  		tsvector_update_trigger(brand_tsv, 'pg_catalog.simple', brand);

		  CREATE TRIGGER keywordstsvectorupdate BEFORE INSERT OR UPDATE
			ON products FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(keywords_tsv, 'pg_catalog.simple', keywords);

      CREATE TRIGGER specstsvectorupdate BEFORE INSERT OR UPDATE
			ON products FOR EACH ROW EXECUTE PROCEDURE
			tsvector_update_trigger(specs_tsv, 'pg_catalog.simple', specs);
		SQL
  end
end
