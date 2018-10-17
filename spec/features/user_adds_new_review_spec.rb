require 'rails_helper'

describe 'add review page' do
  before(:each) do
    @book = Book.create(title: "Huckleberry Finn", pages: 210, year: 1950)
    author = @book.authors.create(name: "Mark Twain")
    @user = User.create(name: "Joe Shmoe")
  end
  it 'user sees book info' do
    visit new_book_review_path(@book)

    expect(page).to have_content("Huckleberry Finn")
    expect(page).to have_content("210")
    expect(page).to have_content("1950")
    expect(page).to have_content("Mark Twain")
  end
  it 'form submission adds a new review' do
    visit new_book_review_path(@book)
    fill_in("user_name", with: "Marky Mark")
    fill_in("review[title]", with: "This book rulez!")
    fill_in("review[description]", with: "I'd read this book like a million times")
    fill_in("review[rating]", with: "4")
    click_button("Add Review")

    expect(@book.reviews.last.title).to have_content("This book rulez!")
  end
  it 'redirects to book show page upon submission' do
    # TODO: Add this test!
    visit new_book_review_path(@book)
    fill_in("user_name", with: "Marky Mark")
    fill_in("review[title]", with: "This book rulez!")
    fill_in("review[description]", with: "I'd read this book like a million times")
    fill_in("review[rating]", with: "4")
    click_button("Add Review")

    expect(page).to have_current_path(book_path(@book))
  end
end
