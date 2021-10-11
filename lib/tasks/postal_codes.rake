#!/usr/bin/env ruby --encoding utf-8
namespace :postcodes do
  require 'logger'
  
  desc "Initialize postcodes table with data given by geonames.org"
  task :init => :environment do |task|
    include PostcodesHelper
    logger = Logger.new("log/postcodes_init_task.log")
    logger.info("STARTED postcodes_init_task")
    begin
      paths = save_postcodes_file
      paths.each do |path|
        import_postcodes_info path
      end
    rescue => e
      logger.error("#{e.message}\n #{e.backtrace.join("\n")}")
    end
    logger.info("ENDED postcodes_init_task")
  end

  desc "Import postcodes from S3 zip"
  task :import_from_s3, [:file_path] => :environment do |task, args|
    include PostcodesHelper
    import_postcodes_into_db()
  end

  desc "Import postcodes data from given file"
  task :import, [:file_path] => :environment do |task, args|
    include PostcodesHelper
    if args.file_path.blank?
      puts "error - missing :file_path param"
      puts "usage: rake postcodes:import[file_path]"
      exit(1)
    else
      logger = Logger.new("log/postcodes_import_task.log")
      logger.info("STARTED postcodes_import_task")
      begin
        import_postcodes_info args.file_path
      rescue => e
        logger.error("#{e.message}\n #{e.backtrace.join("\n")}")
      end
      logger.info("ENDED postcodes_import_task")
    end
  end

end
