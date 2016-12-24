# encoding: utf-8

class BookimageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  storage :aws
  
  def default_url
    "/#{model.class.to_s.downcase}_missing.png"
  end
  
  def store_dir
      "images/#{model.class.table_name.singularize.underscore}/#{model.id}"
  end

  version :medium do
    process :resize_to_fit => [800, 600]
  end
  
  version :small  do 
    process :resize_to_fit => [150, 150]
  end
  
  version :box do
    process :resize_to_fill => [400, 400]
  end
  
  version :thumb do
    process :resize_to_fill => [100, 100]
  end

end
