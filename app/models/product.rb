class Product < ApplicationRecord
	include PgSearch::Model

  belongs_to :category
  belongs_to :shop, class_name: "Shop", foreign_key: 'shop_id'
  has_one_attached :main_image

  validates :name, uniqueness: true

  # pg_search_scope :search_full_text,
  # 	against: { 
  # 		name: 'D', 
  #     brand: 'C',
  #     keywords: 'D',
  #     description: 'A',
  #     specs: 'A',
  # 	},
  # 	using: {
  # 		tsearch: {
  #       normalization: 0,
  # 			dictionary: 'english',
  # 			prefix: true,
  # 			tsvector_column: ["name_tsv", "brand_tsv", "keywords_tsv", "description_tsv", "specs_tsv"]
  # 		}
  # 	}

  pg_search_scope :search_full_text, 
    against:[
      [:title, 'A'],
      [:keywords, 'B'],
      [:brand, 'B'],
      [:description, 'D'],
      [:specs, 'D'],
    ],
    using: {
      tsearch: {
        any_word: true,
        # dictionary: 'english',
        tsvector_column: ["title_tsv", "keywords_tsv", "brand_tsv", "description_tsv", "specs_tsv"]
      },
      trigram: {
        threshold: 0.19,
        only: [:title, :keywords, :brand]
      }
    }

  # Performances of Product.search_full_text("wood") from rails console
  # 518 products:
  # - without ts_vector columns: 60.6ms, 62.8ms, 62.9ms, 62.8ms, 67.2ms
  # - within ts_vector columns: 15.0ms, 17.6ms, 11.7ms, 17.0ms, 15.9ms
  # 3108 products:
  # - without ts_vector columns: 318.8ms, 313.7ms, 308.3ms, 308.5ms, 308.1ms
  # - within ts_vector columns: 56.7ms, 57.4ms, 58.2ms, 55.4ms, 61.0ms
  # 49728 products:
  # - without ts_vector columns: 2316ms, 2268ms, 2248ms, 2295ms, 2297.1ms
  # - within ts_vector columns: 795.2ms, 816.1ms, 819.9ms, 805.4ms, 807.7ms
  
end
