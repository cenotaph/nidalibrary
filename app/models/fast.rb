class Fast < ApplicationRecord
  has_many :books_fasts
  has_many :books, through: :books_fasts

end
