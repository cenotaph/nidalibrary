# frozen_string_literal: true

module Api::V1
  # device types controller. admins only?
  class DeweysController < ApiController
    before_action :authenticate_user! , except: %i[show books index]
    
    def all_books
      @books = Book.where("ddc is not null").order(:call_number).group_by(&:ddc)
      render json: {books: @books }.to_json, status: :ok
    end
    
    def books
      # get all subcodes, first figure out precision
      upper_limit = Dewey.tree_limit(params[:code])
      @dewey = Dewey.where(["code >= ? and code < ?", params[:code], upper_limit])
      @books = Book.preload(:fasts).where(["ddc >= ? and ddc < ?", params[:code], upper_limit]).order(:ddc).group_by(&:ddc)
      @books.each do |code, books|
        @books[code] = BookSerializer.new(books).serializable_hash
      end
      if @dewey.empty?
        # set lower limit?
        @dewey = Dewey.where(["code >= ? and code < ?", params[:code][0] + "00", upper_limit])
        # @dewey = [Dewey.new(code: params[:code], name: 'Unknown')]
      end
      render json: {books: @books, classification:  DeweySerializer.new(@dewey).serializable_hash }.to_json, status: :ok
    end
      
    def create
      @dewey = Dewey.new(dewey_params)
      if @dewey.save
        render json: DeweySerializer.new(@dewey).serializable_hash.to_json, status: :created
      else
        respond_with_errors(@dewey) 
      end
    end

    def update
      @dewey = Dewey.find_by(code: params[:id])
      if @dewey.update(dewey_params)
        render json: DeweySerializer.new(@dewey).serializable_hash.to_json, status: 200
      else
        respond_with_errors(@dewey)
      end
    end

    protected

    def dewey_params
      params.require(:dewey).permit(:code, :name)
    end

  end
end
    