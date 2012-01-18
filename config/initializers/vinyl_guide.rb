module VinylGuide
  properties_file = YAML.load_file("#{Rails.root}/config/build.#{Rails.env}.yml")
  STORAGE_DIR = Dir.new(properties_file["store_path"])
  EBAY_API_KEY = properties_file["ebay_api_key"]
  SOLR_HOME_PATH = properties_file["solr_home_path"]
  BASE_PATH = properties_file["base_path"]
end