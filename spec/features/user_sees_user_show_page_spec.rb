require 'rails_helper'

describe 'user show page' do
  before(:each) do
    @user = User.create(name: "Joe Shmoe")

    book_1 = Book.create(title: "Huckleberry Finn", pages: 210, year: 1950)
    author = book_1.authors.create(name: "Mark Twain")
    book_1.reviews.create(title: "Awesome book!", description: "This book is totally awesome", rating: 5, user: @user)

    book_2 = Book.create(title: "Dune", pages: 900, year: 1950)
    author = book_2.authors.create(name: "Frank Herbert")
    book_2.reviews.create(title: "Worst book!", description: "This book is awful", rating: 1, user: @user)

    book_3 = Book.create(title: "Pride and Prejudice", pages: 130, year: 1950)
    author = book_3.authors.create(name: "Jane Austen")
    book_3.reviews.create(title: "Pretty Good!", description: "This book is super great!", rating: 4, user: @user)

    @books = [book_1, book_2, book_3]
  end
  it 'visitor sees info about user' do
    visit user_path(@user)

    within '#user-info' do
      expect(page).to have_content(@user.name)
      within '#reviews-block' do
        @user.reviews.each do |review|
          expect(page).to have_content(review.title)
          expect(page).to have_content(review.description)
          expect(page).to have_content("Rating: #{review.rating}")
        end
      end
    end
  end
  it 'visitor can sort user reviews chronologically ascending' do
    visit user_path(@user)
    click_on "Newest First"

    expect(page).to have_current_path(user_path(@user, sort_order: 'desc'))
    within '#reviews-block' do
      expect(all('.review')[0]).to have_content("Awesome book!")
      expect(all('.review')[0]).to have_content("This book is totally awesome")
      expect(all('.review')[0]).to have_content("Rating: 5")
      expect(all('.review')[1]).to have_content("Worst book!")
      expect(all('.review')[1]).to have_content("This book is awful")
      expect(all('.review')[1]).to have_content("Rating: 1")
      expect(all('.review')[2]).to have_content("Pretty Good!")
      expect(all('.review')[2]).to have_content("This book is super great!")
      expect(all('.review')[2]).to have_content("Rating: 4")
    end
  end
  it 'visitor can sort user reviews chronologically descending' do
    visit user_path(@user)
    click_on "Oldest First"

    expect(page).to have_current_path(user_path(@user, sort_order: 'asc'))
  end
end
