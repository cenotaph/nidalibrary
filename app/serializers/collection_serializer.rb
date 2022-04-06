class CollectionSerializer
  include JSONAPI::Serializer
  attributes :name, :active, :number
  attribute :book_count do |object|
    object.books.count
  end
end
