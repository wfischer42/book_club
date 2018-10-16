class AuthorsController < ApplicationController

  def show
    @author = Author.find(params[:id])
  end

  def destroy
    Book.destroy_books_with_single_author(params[:id])
    Author.find(params[:id]).destroy
    redirect_to(books_path)
  end
end
