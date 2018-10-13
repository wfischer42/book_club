require "rails_helper"

describe 'user deletes a book' do
  describe 'they link from the book show page' do
    it 'displays all books without the deleted book' do

      book_1 = Book.create(title: "Huckleberry Finn", pages: 210, year: 1950)
      book_1.authors.create(name: "Pen Pal")
      book_1.authors.create(name: "Writer Magee")
      book_2 = Book.create(title: "Dune", pages: 900, year: 1950)
      user = User.create(name: "Joy Opinions")
      review_1 = user.reviews.create(title: "Joyful book", description: "This book brought joy to my life", rating: 4, book_id: book_1.id)
      review_2 = user.reviews.create(title: "No joy", description: "None of the joys were brought by reading this", rating: 2, book_id: book_2.id)

      visit book_path(book_1)
      click_link "Delete"

      expect(current_path).to eq(books_path)
      expect(page).to have_content(book_2.title)
      expect(page).not_to have_content(book_1.title)
    end
  end
end
