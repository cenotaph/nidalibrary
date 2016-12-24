class SearchController < ApplicationController
  
  def search
    if params[:searchterm]
      books = Book.all
      @hits = BookFilter.new.filter(books, params[:searchterm])
    else
      redirect_to '/'
    end
  end

end