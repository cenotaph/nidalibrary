# frozen_string_literal: true

module Api::V1
  # device types controller. admins only?
  class FastsController < ApiController
    before_action :authenticate_user! , only: [:shelfread]
    respond_to :json

    def index
      render json: FastSerializer.new(Fast.all.order(books_count: :desc)).serializable_hash.to_json, status: 200
    end

    def show
      @fast = Fast.find(params[:id])
      render json: FastSerializer.new(@fast).serializable_hash.to_json, status: 200
    end
    
  end

end
    