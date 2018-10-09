require 'rails_helper'

describe 'book index' do
  it 'user sees all books' do
    book_1 = Book.create(title: "Huckleberry Finn", pages: 250, year: 1950)
    author = book_1.authors.create(name: "Mark Twain")

    visit '/books'

    expect(page).to have_content(book_1.title)
    expect(page).to have_content(book_1.pages)
    expect(page).to have_content(book_1.year)
    expect(page).to have_content(author.name)    
  end
end
