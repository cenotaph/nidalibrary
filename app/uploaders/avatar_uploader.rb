class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :aws
  
  def default_url
    "/#{model.class.to_s.downcase}_missing.png"
  end
  
  def store_dir
      "images/#{model.class.table_name.singularize.underscore}/#{model.id}"
  end
  version :small  do 
    process :resize_to_fit => [150, 150]
  end

end