class BooksController < ApplicationController

  def index
    @books = Book.with_avg_rating(nil) if !params[:sort_by]
    @books = Book.with_avg_rating(params[:direction]) if params[:sort_by] == "avg_rating"
  end
end
