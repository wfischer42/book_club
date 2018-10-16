class BooksController < ApplicationController

  def index
    good_params = params.permit(:direction, :sort_by)
    @books = Book.with_avg_rating(good_params[:direction], good_params[:sort_by])
    @ordered_books = Book.with_avg_rating("desc", "avg_rating")
    # TODO: refactor by moving Active Record method calls into the model file
    @books_top_3 = @ordered_books.take(3)
    @books_bottom_3 = @ordered_books.last(3).reverse
    @top_3_reviewers = User.top_three_reviewers
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def create
    params.require(:book).permit(:title, :pages, :year, :authors)
    book_params = process_params(params)
    if book_params == nil
      book = Book.find_by(title: params[:book][:title].titleize)
      redirect_to book_path(book)
    else
      book = Book.create!(book_params)
      redirect_to(book_path(id: book.id)) if book.id
    end
  end

  def process_params(params)
    book_params = {}
    book_params[:title] = params["book"]["title"].titleize
    return nil if Book.find_by(title: book_params[:title])
    book_params[:pages] = params["book"]["pages"]
    book_params[:year] = params["book"]["year"]
    book_params[:authors] = process_authors(params["book"]["authors"])
    book_params
  end

  def process_authors(auth_string)
    auth_string.titleize.split(',').map do |author_name|
      author_name = author_name.strip
      Author.find_by(name: author_name) || Author.create(name: author_name)
    end
  end

  def destroy
    book = Book.find(params[:id])
    book = Book.find(params[:id]).destroy
    redirect_to(books_path)
  end
end
