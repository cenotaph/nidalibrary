# frozen_string_literal: true

module Api::V1
  # device types controller. admins only?
  class SearchController < ApiController
    # before_action :authenticate_user! , except: %i[show index]
    # skip_load_and_authorize_resource only: %i[create destroy index]
    respond_to :json
  
    def search
      params[:page] ||= 1
      if params[:searchterm]
        books = Book.all
        @hits = BookFilter.new.filter(books, params[:searchterm]).page(params[:page]).per(50)
        options = {}
        options[:meta] = { total: @hits.total_pages }
        options[:links] = {
          self: v1_search_path(searchterm: params[:searchterm], page: params[:page]),
          next: params[:page].to_i < @hits.total_pages ? v1_search_path(searchterm: params[:searchterm], page: params[:page].to_i  + 1) : nil, 
          prev: params[:page].to_i  == 1 ? nil : v1_search_path(searchterm: params[:searchterm], page:  params[:page].to_i  - 1)
        }
        render json: BookSerializer.new(@hits, options).serialized_json, status: 200
      else
        redirect_to '/'
      end
    end
  end
end