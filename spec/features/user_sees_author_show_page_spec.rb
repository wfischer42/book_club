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
    user = User.new(name: "Mega Reviewer")
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

    expect(page).to have_current_path("/authors/#{author_2.id}")

    within '#author-books' do
    expect(page).to have_content(book_1.authors[0].name)
    expect(page).not_to have_content(book_1.authors[1].name)
    end
  end
  it 'user sees a highest review rating next to each book title' do
    author = Author.create(name: "J.K. Rowling")
    author_2 = Author.create(name: "C.S. Lewis")
    author_3 = Author.create(name: "HR Shovenstuff")
    book_1 = Book.create(title: "Lion, Witch, and Wardrobe", pages: 800, year: 1925)
    book_2 = Book.create(title: "Another Book", pages: 300, year: 1960)
    book_3 = Book.create(title: "Title", pages: 125, year: 1970)
    user = User.create(name: "Bozo")
    book_1.authors << [author, author_2]
    book_1.reviews.create(title: "Worst book!", description: "This book is awful", rating: 1, user_id: user.id)
    book_1.reviews.create(title: "Killer good!", description: "This book is ok", rating: 5, user_id: user.id)
    book_1.reviews.create(title: "Okay book", description: "This book is ok", rating: 3, user_id: user.id)

    visit author_path(author_2)

    expect(page).to have_current_path("/authors/#{author_2.id}")

    expect(page).to have_content(book_1.reviews[1].title)
    expect(page).not_to have_content(book_1.reviews[2].title)
  end
end
