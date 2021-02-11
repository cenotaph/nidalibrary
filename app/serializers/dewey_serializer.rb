class DeweySerializer
  include JSONAPI::Serializer
  attributes :code, :name
  attribute :name_with_ancestry do |obj|
    obj.name_with_ancestry rescue ''
  end
end
