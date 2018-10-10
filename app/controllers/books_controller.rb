class BooksController < ApplicationController

  def index
    @books = Book.with_avg_rating(params[:direction], params[:sort_by])
    @ordered_books = Book.with_avg_rating("desc", "avg_rating")
    # TODO: refactor by moving Active Record method calls into the model file
    @books_top_3 = @ordered_books.take(3)
    @books_bottom_3 = @ordered_books.last(3).reverse
    @top_3_reviewers = User.top_three_reviewers
  end

  def show
    @book = Book.find(params[:id])
  end
end
