CarrierWave.configure do |config|  
    config.storage = :aws
    config.aws_credentials = {
      :access_key_id      => ENV['amazon_access_key'],
      :secret_access_key  => ENV['amazon_secret_key'], 
      region: 'eu-central-1'
    }
    config.aws_acl    = :public_read

    config.aws_bucket  = "nidalibrary"


  # config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end

