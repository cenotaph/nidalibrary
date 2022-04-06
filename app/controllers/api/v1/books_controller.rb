# frozen_string_literal: true

module Api::V1
  # device types controller. admins only?
  class BooksController < ApiController
    before_action :authenticate_user! , except: %i[show index]
    # skip_load_and_authorize_resource only: %i[create destroy index]
    respond_to :json

    def create
      @book = Book.new(book_params)
      if @book.save
        render json: BookSerializer.new(@book).serializable_hash.to_json, status: :created
      else
        respond_with_errors(@book) 
      end
    end

    def destroy
      @book = Book.find(params[:id])
      if @book.destroy
        head :no_content
      else
        respond_with_errors(@book) 
      end
      
    end
    
    def index
      params[:page] ||= 1
      if params[:collection_id]
        @collection = Collection.friendly.find(params[:collection_id])
        @books = @collection.books.order(:call_number).page(params[:page]).per(50)
      elsif params[:section_id]
        @section = Section.friendly.find(params[:section_id])
        @books = @section.books.order(:catno).page(params[:page]).per(50)
      elsif params[:fast_id]
        @section = Fast.find(params[:fast_id])
        @books = @section.books.page(params[:page]).per(50)
      elsif params[:status_id]
        @status = Status.friendly.find(params[:status_id])
        @books = @status.books.order(:section_id, :catno).page(params[:page]).per(50)
      elsif params[:format] == 'csv'
        require 'csv'
        @books = Book.all.order("id desc, updated_at, catno")
        respond_to do |format|
          format.csv do
            headers['Content-Disposition'] = "attachment; filename=\"book-list\""
            headers['Content-Type'] ||= 'text/csv'
          end
        end
      else

        @books = Book.order("id desc, updated_at, catno").page(params[:page]).per(50)
      end
      options = {}
      options[:meta] = { total: @books.total_pages }
      options[:links] = {
        self: params[:section_id] ? v1_section_books_path(@section.slug) : v1_books_path(),
        next: params[:page].to_i < @books.total_pages ? (params[:section_id] ? v1_section_books_path(@section.slug, page: params[:page].to_i  + 1) : v1_books_path(page: params[:page].to_i  + 1)) : nil, 
        prev: params[:page].to_i  == 1 ? nil : (params[:section_id] ? v1_section_books_path(@section.slug, page: params[:page].to_i  - 1) : v1_books_path(page:  params[:page].to_i  - 1))
      }
      render json: BookSerializer.new(@books, options).serializable_hash.to_json, status: 200
    end

    def search_oclc
      if params[:search] =~ /^978/ 
        # search by isbn
        @book = Book.search_isbn(params[:search])
        if @book
          @book.isbn13 = params[:search].gsub(/\D/, '')
          Rails.logger.error @book.inspect
          render json: BookSerializer.new(@book).serializable_hash.to_json, status: 200
        else
          render json: {}, status: 404
        end
      end

    end
    

    def show
      @book = Book.find(params[:id])
      render json: BookSerializer.new(@book).serializable_hash.to_json, status: 200
    end

    def update
      @book = Book.find(params[:id])
      if @book.update(book_params)
        render json: BookSerializer.new(@book).serializable_hash.to_json, status: 200
      else
        respond_with_errors(@book)
      end
    end

    private

    def book_params
      params.require(:book).permit(:isbn10, :oclc, :artist, :isbn13, :image, :title, :language, :section_id, :status_id, :publisher, :summary, :pages, :year_published, :author, :subtitle, :comment, :catno, :provenance, :slug, :ddc, :call_number, :lcc, :copies, :author_is_editor,:author_is_institution, :contributors, :collection_id)
    end
  end
end