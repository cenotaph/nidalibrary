class BooksFast < ApplicationRecord
  belongs_to :book
  belongs_to :fast
  counter_culture :fast, column_name: 'books_count'

  validates :fast_id, uniqueness: { scope: :book_id }
end

  