#config/initializers/carrierwave.rb
CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                                      # required
    :aws_access_key_id      => 'AKIAIGVNEJUWP6KDGC6A',                     # required
    :aws_secret_access_key  => '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'  # required
  }
  config.fog_directory  = 'The_WEB_Project'                                # required
  config.fog_host       = 'http://The_WEB_Project.s3.amazonaws.com/'       # optional, defaults to nil
  config.fog_public     = false                                            # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}           # optional, defaults to {}
end