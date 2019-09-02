# frozen_string_literal: true

class BookSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :isbn10, :isbn13, :title, :language, :publisher, :pages, :year_published, :author, :subtitle, :comment, :catno, :provenance, :created_at, :updated_at, :image_url, :summary, :section_id, :status_id
  attribute :section do |object|
    object.section.try(:name)
  end

  attribute :status do |object|
    object.status.try(:name)
  end
end
