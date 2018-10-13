class AuthorsController < ApplicationController

  def show
    @author = Author.find(params[:id])
  end

  def destroy
    Book.destroy_books_with_single_author(params[:id])
    Author.find(params[:id]).destroy
    #
    # where(author_id: author_id).destroy
    # books_to_delete.destroy
    # redirect_to(authors_path())
  end
end
