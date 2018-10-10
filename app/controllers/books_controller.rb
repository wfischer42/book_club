class BooksController < ApplicationController

  def index
    @books = Book.with_avg_rating(params[:direction], params[:sort_by])
  end
end
