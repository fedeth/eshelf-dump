module PostcodesHelper

  DOWNLOAD_URL = "https://eshelf-static-files.s3.eu-west-2.amazonaws.com/ukpostcodes.zip"
  POSTCODES_FILE_PATH = "resources"
  FILE_NAME = "GB_full.txt"
  LONDON_OFFICIAL_FILE_NAME = "LONDON_full.txt"
  require 'open-uri'
  require 'zip'

  def import_postcodes_into_db()
    logger = Logger.new("log/postcodes_import_task.log")
    logger.info("STARTED import_postcodes_into_db")
    logger.info("START DOWNLOAD of ukpostcodes.zip")
    file = open(DOWNLOAD_URL)
    logger.info("COMPLETE DOWNLOAD of ukpostcodes.zip")
    result_files_paths = []
    Zip::File.open(file) do |zip_file|
      zip_file.each do |f|
        fpath = File.join(Rails.root, "tmp", f.name)
        zip_file.extract(f, fpath){ true }
        result_files_paths << fpath
      end
    end
    result_files_paths.each do |file_path|
      postcodes = []
      File.open(file_path).each_line do |line|
        record = line.gsub("\n","").gsub("\r","").split(",")
        postcodes.push({
          postcode: record[1],
          latitude: record[2].to_f,
          longitude: record[3].to_f
        })
      end
      postcodes.each_slice(10000) do |postcodes_slice|
        Postcode.import(postcodes_slice, on_duplicate_key_update: {conflict_target: [:postcode], columns: [:latitude, :longitude]})
        logger.info("10000 postcodes imported, last postcode is: #{postcodes_slice.last[:postcode]} ")
      end
      File.delete(file_path) if File.exist?(file_path)
    end
    logger.info("END import_postcodes_into_db")
  end

  def get_possible_postcodes(postcode)
    postcode_combinations = []
    mangled_postcode = postcode.upcase.gsub(/\s+/, "")
    mangled_postcode.length.times do |time|
      mp = mangled_postcode.dup
    postcode_combinations.push(mp.insert(mangled_postcode.length - (time +1)," "))
    postcode_combinations
end

postcode_combinations
  end

  # These methods are going to be deprecated soon
  def save_postcodes_file
    file = open(DOWNLOAD_URL)
    result_files_paths = []
    Zip::File.open(file) do |zip_file|
      zip_file.each do |f|
        fpath = File.join(POSTCODES_FILE_PATH, f.name)
        zip_file.extract(f, fpath){ true }
        result_files_paths << fpath
      end
    end
    result_files_paths
  end

  def import_postcodes_info(source_path)
    postcodes = []
    File.open(source_path).each_line do |line|
      record = line.split("\t")
      postcodes.push({
        postcode: record[1],
        latitude: record[9].to_f,
        longitude: record[10].to_f
      })
    end
    Postcode.import(postcodes, on_duplicate_key_update: {conflict_target: [:postcode], columns: [:latitude, :longitude]})
  end

  def get_source_file
    path = File.join(POSTCODES_FILE_PATH, LONDON_OFFICIAL_FILE_NAME)
    if File.exists? path
      path
    end
  end

end