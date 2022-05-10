class Collection < ApplicationRecord
  validates_presence_of :name
  extend FriendlyId
  friendly_id :name, use: [:slugged]
  has_many :books
  
  before_destroy :check_if_empty
  scope :active, ->() { where(active: true) }
  scope :inactive, ->() { where(active: false) }

  def check_if_empty
    unless books.empty?
      throw(:abort)
    end
  end
end
