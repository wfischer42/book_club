require 'rails_helper'

describe 'author show page' do
  it 'user sees only one authors info' do
    author = Author.create(name: "J.K. Rowling")
    author_2 = Author.create(name: "C.S. Lewis")
    author_3 = Author.create(name: "HR Shovenstuff")

    book_1 = Book.create(title: "Lion, Witch, and Wardrobe", pages: 800, year: 1925)
    book_2 = Book.create(title: "Another Book", pages: 300, year: 1960)

    book_1.authors << [author]
    book_2.authors << [author_2, author_3]

    visit author_path(author)

    expect(page).to have_current_path("/authors/#{author.id}")

    expect(page).to have_content(author.name)
    expect(page).not_to have_content(author_2.name)
  end
  it 'user sees all books written by that one author' do
    author = Author.create(name: "J.K. Rowling")
    author_2 = Author.create(name: "C.S. Lewis")
    author_3 = Author.create(name: "HR Shovenstuff")

    book_1 = Book.create(title: "Lion, Witch, and Wardrobe", pages: 800, year: 1925)
    book_2 = Book.create(title: "Another Book", pages: 300, year: 1960)
    book_3 = Book.create(title: "Harry Potter", pages: 125, year: 1970)

    book_1.authors << [author, author_2]
    book_2.authors << [author_2]

    visit author_path(author_2)

    expect(page).to have_current_path("/authors/#{author_2.id}")

    expect(page).to have_content(author_2.books[0].title)
    expect(page).to have_content(author_2.books[1].title)
    expect(page).not_to have_content(book_3.title)
  end
  it 'user sees all co-authors for all show author books' do
    author = Author.create(name: "J.K. Rowling")
    author_2 = Author.create(name: "C.S. Lewis")
    author_3 = Author.create(name: "HR Shovenstuff")

    book_1 = Book.create(title: "Lion, Witch, and Wardrobe", pages: 800, year: 1925)
    book_2 = Book.create(title: "Another Book", pages: 300, year: 1960)
    book_3 = Book.create(title: "Title", pages: 125, year: 1970)

    book_1.authors << [author, author_2]

    visit author_path(author_2)
    save_and_open_page
    expect(page).to have_current_path("/authors/#{author_2.id}")

    within '#author-books' do
    expect(page).to have_content(book_1.authors[0].name)
    expect(page).not_to have_content(book_1.authors[1].name)
  end
  end

end
