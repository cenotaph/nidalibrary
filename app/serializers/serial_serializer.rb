# frozen_string_literal: true

class SerialSerializer
  include JSONAPI::Serializer
  attributes :id, :issn, :title, :subtitle, :volume, :number, :year, :publisher, :month
  


  attribute :status do |object|
    object.status.try(:name)
  end
end
