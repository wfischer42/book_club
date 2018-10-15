class ReviewsController < ApplicationController

  def new
    @book = Book.find(params[:book_id])
    @review = Review.new
  end

  def create
    user = User.find_or_create_by(name: params[:user_name].titleize)
    book = Book.find(params[:book_id])
    review_params = params.require(:review).permit(:title, :description, :rating)
    review_params[:user] = user
    review = book.reviews.create!(review_params)
    review.user = user
    redirect_to(book_path(book))
  end

  def destroy
    Review.find(params[:id]).destroy
    redirect_to(user_path(id: params[:user_id]))
  end

end
