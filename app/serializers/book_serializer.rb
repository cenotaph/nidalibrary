# frozen_string_literal: true

class BookSerializer
  include JSONAPI::Serializer
  attributes :id, :isbn10, :isbn13, :title, :copies, :language, :publisher, :pages, :call_number, :year_published, :author, :subtitle, :comment, :catno, :provenance, :created_at, :updated_at, :image_url, :summary, :status_id, :oclc, :ddc, :lcc, :not_found, :author_is_editor, :author_is_institution, :artist

  attribute :collection_id
  
  attributes :fast_headings do |obj|
    obj.fasts
  end

  attribute :section_id do |obj|
    obj.section_id.nil? ? 0 : obj.section_id 
  end

  attribute :section do |object|
    object.section.try(:name)
  end

  attribute :status do |object|
    object.status.try(:name)
  end
end
