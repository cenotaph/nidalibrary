# frozen_string_literal: true

module Api::V1
  # device types controller. admins only?
  class SectionsController < ApiController
    before_action :authenticate_user! , only: [:shelfread]
    respond_to :json

    def index
      render json: SectionSerializer.new(Section.includes(:books)).serialized_json, status: 200
    end

    def shelfread
      @section = Section.friendly.find(params[:id])
      @books = @section.books.order(:catno)
      render json: BookSerializer.new(@books).serialized_json, status: :ok
    end
  end
end
