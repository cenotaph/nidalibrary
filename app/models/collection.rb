class Collection < ApplicationRecord
  validates_presence_of :name
  extend FriendlyId
  friendly_id :name, use: [:slugged]
  has_many :books
  
  scope :active, ->() { where(active: true) }
  scope :inactive, ->() { where(active: false) }
end
