class Book < ApplicationRecord
  belongs_to :section
  belongs_to :status
  validates_presence_of :title, :catno
  
  extend FriendlyId
  friendly_id :title, use: [:slugged]
  mount_uploader :image, BookimageUploader
  before_save :update_image_attributes
  
  
  private
  

  
  def update_image_attributes
    if image.present? && image_changed?
      if image.file.exists?
        self.image_content_type = image.file.content_type
        self.image_size = image.file.size
        self.image_width, self.image_height = `identify -format "%wx%h" #{image.file.path}`.split(/x/)
      end
    end
  end
end
