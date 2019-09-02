# frozen_string_literal: true

class SectionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :colour
  attribute :book_count do |object|
    object.books.count
  end
end