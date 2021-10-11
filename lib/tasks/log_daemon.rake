#!/usr/bin/env ruby --encoding utf-8
namespace :events_log do
  desc 'Takes data from log files in "log/events" and populates db'
  task :daemon => :environment do
  	require 'json'
  	include EventsLogUtils
    include SystemUtils

    execute_exclusively_with_logs("events_log:daemon") do |logger|
    	Dir.glob("#{Rails.root}/log/events/*.json").each do |log_path|
    		log_file = File.read(log_path)
        logger.debug("processing file #{log_path}")
    		log_info = JSON.parse(log_file, :symbolize_names => true)
    		new_db_log = log_event_to_db(log_info,false)
        logger.debug("file data saved in record with id #{new_db_log.id}")
    		File.delete(log_path) if File.exist?(log_path)
        logger.debug("deleted file #{log_path}")
    	end
    end
  end 
end