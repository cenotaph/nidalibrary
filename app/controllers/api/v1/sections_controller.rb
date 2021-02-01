# frozen_string_literal: true

module Api::V1
  # device types controller. admins only?
  class SectionsController < ApiController
    before_action :authenticate_user! , only: [:shelfread]
    respond_to :json

    def fasts
      render json: FastSerializer.new(Fast.all.order(books_count: :desc)).serializable_hash.to_json, status: 200
    end
    
    def index
      render json: SectionSerializer.new(Section.includes(:books)).serializable_hash.to_json, status: 200
    end

    def shelfread
      @section = Section.friendly.find(params[:id])
      @books = @section.books.order(:catno)
      render json: BookSerializer.new(@books).serializable_hash.to_json, status: :ok
    end
  end
end
