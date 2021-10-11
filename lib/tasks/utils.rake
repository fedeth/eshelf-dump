#!/usr/bin/env ruby --encoding utf-8
namespace :utils do
  require 'logger'
  desc "Check categories and products validity before import"
  task :check_products_and_categories => :environment do |task, args|
    include ImportHelper
    categories_path = File.join(Rails.root, "resources", "eshelf_categories.tsv")
    products_path = File.join(Rails.root, "resources", "artist_upload_file_sep_2020.tsv")
    check_categories_and_products_before_import(categories_path, products_path)
  end

  task :import_products, [:product_path, :shop_id,] => :environment do |task, args|
    include ImportHelper
    products_path = File.join(Rails.root, "resources", args.product_path)
    import_initial_products(products_path, args.shop_id.to_i)
  end

  # rake utils:update_products_quantity[eshelf_products.tsv] # artist_upload_file_sep_2020_rev.tsv
  task :update_products_quantity, [:product_file_name] => :environment do |task, args|
    include ImportHelper
    products_path = File.join(Rails.root, "resources", args.product_file_name)
    update_product_quantity(products_path)
  end
end
