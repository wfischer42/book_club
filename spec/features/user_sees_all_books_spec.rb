require 'rails_helper'

describe 'book index' do
  before(:each) do
    book_1 = Book.create(title: "Huckleberry Finn", pages: 210, year: 1950)
    author = book_1.authors.create(name: "Mark Twain")
    user = User.create(name: "Joe Shmoe")
    book_1.reviews.create(title: "Awesome book!", description: "This book is totally awesome", rating: 5, user_id: user.id)
    book_1.reviews.create(title: "Crappiest book", description: "This book is terrible", rating: 1, user_id: user.id)

    book_2 = Book.create(title: "Dune", pages: 900, year: 1950)
    author = book_2.authors.create(name: "Frank Herbert")
    book_2.reviews.create(title: "Worst book!", description: "This book is awful", rating: 1, user_id: user.id)

    book_3 = Book.create(title: "Pride and Prejudice", pages: 130, year: 1950)
    author = book_3.authors.create(name: "Jane Austen")
    book_3.reviews.create(title: "Awesome book!", description: "This book is super great!", rating: 5, user_id: user.id)
    book_3.reviews.create(title: "Uh...", description: "I don't get it.", rating: 5, user_id: user.id)
    book_3.reviews.create(title: "Best book evaarrr!", description: "This book is super great!", rating: 5, user_id: user.id)
    @books = [book_1, book_2, book_3]
  end
  it 'user sees all books' do
    visit '/books'

    expect(page).to have_content(@books[0].title)
    expect(page).to have_content(@books[0].pages)
    expect(page).to have_content(@books[0].year)
    expect(page).to have_content(@books[0].authors[0].name)
  end
  it 'user sees rating statistics per book' do
    visit '/books'

    expect(page).to have_content("Average Rating: 3")
    expect(page).to have_content("Total Reviews: 2")
  end

  describe 'user can sort books by' do
    it 'average rating ascending' do
      visit '/books'
      click_on "avg-rating-asc"

      expect(page).to have_current_path(books_path(direction: 'asc',
                                                   sort_by: 'avg_rating'))

      expect(all(".book-title")[0]).to have_content("Dune")
      expect(all(".book-title")[1]).to have_content("Huckleberry Finn")
      expect(all(".book-title")[2]).to have_content("Pride and Prejudice")
    end
    it 'average rating descending' do
      visit '/books'
      click_on 'avg-rating-desc'

      expect(page).to have_current_path(books_path(sort_by: 'avg_rating',
                                                   direction: 'desc'))
      expect(all(".book-title")[0]).to have_content("Pride and Prejudice")
      expect(all(".book-title")[1]).to have_content("Huckleberry Finn")
      expect(all(".book-title")[2]).to have_content("Dune")
    end
    it 'page count ascending' do
      visit '/books'
      click_on 'page-count-asc'

      expect(page).to have_current_path(books_path(sort_by: 'pages',
                                                   direction: 'asc'))

      expect(all(".book-title")[0]).to have_content("Pride and Prejudice")
      expect(all(".book-title")[1]).to have_content("Huckleberry Finn")
      expect(all(".book-title")[2]).to have_content("Dune")
    end
    it 'page count descending' do
      visit '/books'
      click_on 'page-count-desc'

      expect(page).to have_current_path(books_path(sort_by: 'pages',
                                                   direction: 'desc'))

      expect(all(".book-title")[0]).to have_content("Dune")
      expect(all(".book-title")[1]).to have_content("Huckleberry Finn")
      expect(all(".book-title")[2]).to have_content("Pride and Prejudice")
    end
    it 'review count ascending' do
      visit '/books'
      click_on 'review-count-asc'

      expect(page).to have_current_path(books_path(sort_by: 'rev_count',
                                                   direction: 'asc'))

      expect(all(".book-title")[0]).to have_content("Dune")
      expect(all(".book-title")[1]).to have_content("Huckleberry Finn")
      expect(all(".book-title")[2]).to have_content("Pride and Prejudice")
    end
    it 'review count descending' do
      visit '/books'
      click_on 'review-count-desc'

      expect(page).to have_current_path(books_path(sort_by: 'rev_count',
                                                   direction: 'desc'))

      expect(all(".book-title")[0]).to have_content("Pride and Prejudice")
      expect(all(".book-title")[1]).to have_content("Huckleberry Finn")
      expect(all(".book-title")[2]).to have_content("Dune")
    end
  end
end
