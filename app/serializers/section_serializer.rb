# frozen_string_literal: true

class SectionSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :colour
  attribute :book_count do |object|
    object.books.count
  end
end