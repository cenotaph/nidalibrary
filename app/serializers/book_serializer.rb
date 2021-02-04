# frozen_string_literal: true

class BookSerializer
  include JSONAPI::Serializer
  attributes :id, :isbn10, :isbn13, :title, :copies, :language, :publisher, :pages, :call_number, :year_published, :author, :subtitle, :comment, :catno, :provenance, :created_at, :updated_at, :image_url, :summary, :section_id, :status_id, :oclc, :ddc, :lcc, :not_found, :author_is_editor, :author_is_institution

  attributes :fast_headings do |obj|
    obj.fasts
  end

  attribute :section do |object|
    object.section.try(:name)
  end

  attribute :status do |object|
    object.status.try(:name)
  end
end
