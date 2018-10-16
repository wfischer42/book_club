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
    end
    @user.reviews.each do |review|
      expect(page).to have_content(review.title)
      expect(page).to have_content(review.description)
      expect(page).to have_content("#{review.rating} stars")
    end
  end

  it 'visitor sees info about books being reviewed' do
    visit user_path(@user)
    @user.reviews.each do |review|
      expect(page).to have_content(review.book.title)
      review.book.authors.each do |author|
        expect(page).to have_content(author.name)
      end
    end
  end

  it 'book title links to book show pages' do
    visit user_path(@user)
    click_on @books[0].title
    expect(page).to have_current_path(book_path(id: @books[0].id))
  end

  it 'author name links to author show page' do
    visit user_path(@user)
    author = @books[0].authors.first
    click_on author.name
    expect(page).to have_current_path(author_path(id: author.id))
  end

  it 'visitor can sort user reviews chronologically ascending' do
    visit user_path(@user)
    click_on "Newest First"

    expect(page).to have_current_path(user_path(@user, sort_order: 'desc'))
    expect(all('.review-block')[2]).to have_content("Awesome book!")
    expect(all('.review-block')[2]).to have_content("This book is totally awesome")
    expect(all('.review-block')[2]).to have_content("5 stars")
    expect(all('.review-block')[1]).to have_content("Worst book!")
    expect(all('.review-block')[1]).to have_content("This book is awful")
    expect(all('.review-block')[1]).to have_content("1 stars")
    expect(all('.review-block')[0]).to have_content("Pretty Good!")
    expect(all('.review-block')[0]).to have_content("This book is super great!")
    expect(all('.review-block')[0]).to have_content("4 stars")
  end
  it 'visitor can sort user reviews chronologically descending' do
    visit user_path(@user)
    click_on "Oldest First"

    expect(page).to have_current_path(user_path(@user, sort_order: 'asc'))
  end
end
