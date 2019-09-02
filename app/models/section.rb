class Section < ApplicationRecord
  validates_presence_of :name
  extend FriendlyId
  friendly_id :name, use: [:slugged]
  has_many :books
end
