# frozen_string_literal: true

module Api::V1
  # device types controller. admins only?
  class CollectionsController < ApiController
    before_action :authenticate_user! , only: [:shelfread]
    respond_to :json

    def create
      @collection = Collection.new(collection_params)
      if @collection.save
        render json: CollectionSerializer.new(@collection).serializable_hash.to_json, status: :created
      else
        respond_with_errors(@collection) 
      end
    end

    def index
      render json: CollectionSerializer.new(Collection.all.order(:number)).serializable_hash.to_json, status: 200
    end

    def show
      @collection = Collection.friendly.find(params[:id])
      @books = @collection.books.order(:call_number)
      render json: CollectionSerializer.new(@collection).serializable_hash.to_json, status: :ok
    end
    
    def update
      @collection = Collection.friendly.find(params[:id])
      if @collection.update(collection_params)
        render json: CollectionSerializer.new(@collection).serializable_hash.to_json, status: 200
      else
        respond_with_errors(@collection)
      end
    end

    private

    def collection_params
      params.require(:collection).permit(:name, :slug, :number, :active)
    end
  end

end
    