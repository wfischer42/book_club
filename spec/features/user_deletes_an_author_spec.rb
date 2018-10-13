require 'rails_helper'

describe 'user deletes an author' do
  describe 'they link from the author show page' do
    before(:each) do
      @book_1 = Book.create(title: "Huckleberry Finn", pages: 210, year: 1950)
      @book_2 = Book.create(title: "Dune", pages: 900, year: 1950)

      @author_1 = @book_1.authors.create(name: "Mark Twain")
      @author_2 = @book_1.authors.create(name: "Frank Herbert")
      @author_3 = @book_2.authors.create(name: "Ghost Writer")
    end
    it 'removes author entry from database' do
      visit author_path(@author_3)
      click_link "Delete Author"

      expect(Author.exists?(@author_3.id)).to eq(false)
    end

    it 'removes related single author books from database' do
      visit author_path(@author_3)
      click_link "Delete Author"

      expect(Book.exists?(@book_2.id)).to eq(false)
    end

    it 'doesnt remove book if there are multiple authors' do
      visit author_path(@author_2)
      click_link "Delete Author"

      expect(Book.exists?(@book_1.id)).to eq(true)
    end


  end
end
