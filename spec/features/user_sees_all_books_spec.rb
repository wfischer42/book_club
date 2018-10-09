require 'rails_helper'

describe 'book index' do
  before(:each) do
    book_1 = Book.create(title: "Huckleberry Finn", pages: 250, year: 1950)
    author = book_1.authors.create(name: "Mark Twain")
    user = User.create(name: "Joe Shmoe")
    book_1.reviews.create(title: "Awesome book!", description: "This book is totally awesome", rating: 5, user_id: user.id)
    book_1.reviews.create(title: "Crappiest book", description: "This book is terrible", rating: 1, user_id: user.id)
    @books = [book_1]
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
end
