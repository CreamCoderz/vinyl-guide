# symbolize these keys because fog configs don't work with strings.. consider writing a patch
# HashWithIndifferentAccess doesn't work because fog iterates over keys and compare them to symbols.
AMAZON = YAML.load_file("#{Rails.root}/config/amazon.yml").symbolize_keys
AMAZON[:amazon_s3_credentials].symbolize_keys!

CarrierWave.configure do |config|
  config.storage :fog
  config.fog_credentials = AMAZON[:amazon_s3_credentials]
  config.fog_directory  = AMAZON[:amazon_s3_bucket]
  config.fog_host       = AMAZON[:amazon_s3_host]            # optional, defaults to nil
  config.fog_public     = true                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end
