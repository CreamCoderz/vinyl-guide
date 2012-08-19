CarrierWave.configure do |config|
  config.storage :fog
  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => 'AKIAICZTWT6XM6HQCV4Q',       # required
    :aws_secret_access_key  => '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',       # required
    :region                 => 'us-east-1'  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'roots-vinyl-guide'                     # required
  #config.fog_host       = 'https://assets.example.com'            # optional, defaults to nil
  config.fog_public     = true                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end
