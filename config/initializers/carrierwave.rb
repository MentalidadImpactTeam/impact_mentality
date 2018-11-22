CarrierWave.configure do |config|
  # config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     'KPZXEE45FA6VY7YUX6VN',                        # required unless using use_iam_profile
    aws_secret_access_key: 'ZJIpWFctdhmG8cDb2jx4fn4Yh3SdwuYzn9XEE1eWrRs',                        # required unless using use_iam_profile
    use_iam_profile:       false,                         # optional, defaults to false
    region:                'sfo2',                  # optional, defaults to 'us-east-1'
    host:                  'sfo2.digitaloceanspaces.com',             # optional, defaults to nil
    endpoint:              'https://sfo2.digitaloceanspaces.com' # optional, defaults to nil
  }
  config.fog_directory  = 'mentalidadimpact'                                      # required
  config.fog_public     = true                                                 # optional, defaults to true
  config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}
end