require 'rails_helper'

describe 'book index statistics' do
  before(:each) do
    user = User.create(name: "Joe Shmoe")
    user_2 = User.create(name: "Betty Davis")
    user_3 = User.create(name: "Dick Tracey")
    user_4 = User.create(name: "Stick Stickley")

    book_1 = Book.create(title: "Huckleberry Finn", pages: 210, year: 1950)
    author = book_1.authors.create(name: "Mark Twain")
    book_1.reviews.create(title: "Awesome book!", description: "This book is totally awesome", rating: 5, user_id: user.id)
    book_1.reviews.create(title: "Crappiest book", description: "This book is terrible", rating: 1, user_id: user_2.id)

    book_2 = Book.create(title: "Dune", pages: 900, year: 1950)
    author = book_2.authors.create(name: "Frank Herbert")
    book_2.reviews.create(title: "Worst book!", description: "This book is awful", rating: 1, user_id: user.id)

    book_3 = Book.create(title: "Pride and Prejudice", pages: 130, year: 1950)
    author = book_3.authors.create(name: "Jane Austen")
    book_3.reviews.create(title: "Awesome book!", description: "This book is super great!", rating: 5, user_id: user.id)
    book_3.reviews.create(title: "Uh...", description: "I don't get it.", rating: 5, user_id: user_2.id)
    book_3.reviews.create(title: "Best book evaarrr!", description: "This book is super great!", rating: 5, user_id: user_3.id)

    book_4 = Book.create(title: "To Kill a Mockingbird", pages: 130, year: 1950)
    author = book_4.authors.create(name: "Harper Lee")
    book_4.reviews.create(title: "Excellent", description: "This book is super great!", rating: 3, user_id: user.id)
    book_4.reviews.create(title: "Uh...", description: "I don't get it.", rating: 4, user_id: user_2.id)
    book_4.reviews.create(title: "Best book evaarrr!", description: "This book is super great!", rating: 5, user_id: user_3.id)

    @books = [book_1, book_2, book_3, book_4]
  end
  it 'user sees three highest rated books' do
    visit '/books'

    within("#top_3") do
      expect(all(".book-title")[0]).to have_content("Pride and Prejudice")
      expect(all(".book-title")[1]).to have_content("To Kill a Mockingbird")
      expect(all(".book-title")[2]).to have_content("Huckleberry Finn")
    end
  end
  it 'user sees three lowest rated books' do
    visit '/books'

    within("#bottom_3") do
      expect(all(".book-title")[0]).to have_content("Dune")
      expect(all(".book-title")[1]).to have_content("Huckleberry Finn")
      expect(all(".book-title")[2]).to have_content("To Kill a Mockingbird")
    end
  end
  it 'user sees three top reviewers' do
    visit '/books'

    within("#top_reviewers") do
      expect(all(".reviewer-name")[0]).to have_content("Joe Shmoe")
      expect(all(".reviewer-name")[1]).to have_content("Betty Davis")
      expect(all(".reviewer-name")[2]).to have_content("Dick Tracey")
    end
  end
end
