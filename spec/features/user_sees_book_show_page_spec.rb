require 'rails_helper'

describe 'book show page' do
  before (:each) do
    @user = User.create(name: "Joe Shmoe")

    @book = Book.create(title: "Pride and Prejudice", pages: 130, year: 1950)
    @book.authors.create(name: "Jane Austen")
    @book.authors.create(name: "Ghost Writer")
    @book.reviews.create(title: "Decent", description: "This book is super great!", rating: 3, user_id: @user.id)
    @book.reviews.create(title: "Uh...", description: "I don't get it.", rating: 2, user_id: @user.id)
    @book.reviews.create(title: "Best book evaarrr!", description: "This book is super great!", rating: 5, user_id: @user.id)
    @book.reviews.create(title: "Pretty goood!", description: "This book is super great!", rating: 4, user_id: @user.id)

    @other_book = Book.create(title: "Dune", pages: 900, year: 1950)
    author = @other_book.authors.create(name: "Frank Herbert")
  end
  it 'user sees only one book' do
    visit book_path(@book)

    expect(page).to have_current_path(book_path(@book))

    expect(page).to have_content(@book.title)
    expect(page).not_to have_content(@other_book.title)
  end
  it 'user sees details about book' do
    visit book_path(@book)

    expect(page).to have_content(@book.pages)
    expect(page).to have_content(@book.year)
    @book.authors.each do |author|
      expect(page).to have_content(author.name)
    end
  end
  it 'user sees all reviews about book' do
    visit book_path(@book)

    @book.reviews.each do |review|
      expect(page).to have_content(review.title)
      expect(page).to have_content(review.description)
      expect(page).to have_content(review.rating)
      expect(page).to have_content(review.user.name)
    end
  end
  it 'has link to add a new review' do
    visit book_path(@book)
    click_on "Review Book"

    expect(page).to have_current_path(new_book_review_path(@book))
  end
  it 'has link to go to author show page' do
    visit book_path(@book)

    within("#book-info") do
      click_on @book.authors[0].name
    end

    expect(page).to have_current_path(author_path(@book.authors[0]))
  end

  it 'has link to user show page' do
    visit book_path(@book)

    within("#top-review-#{@book.reviews[0].id}") do
      click_on @user.name
    end
    expect(page).to have_current_path(user_path(@user))

    visit book_path(@book)

    within("#bottom-review-#{@book.reviews[0].id}") do
      click_on @user.name
    end
    expect(page).to have_current_path(user_path(@user))

    visit book_path(@book)

    within("#all-reviews-#{@book.reviews[0].id}") do
      click_on @user.name
    end
    expect(page).to have_current_path(user_path(@user))
  end

  describe 'statistics' do
    it 'user sees top 3 reviews' do
      visit book_path(@book)

      expect(all(".top_review")[0]).to have_content("Best book evaarrr!")
      expect(all(".top_review")[0]).to have_content("5 stars")
      expect(all(".top_review")[0]).to have_content("Joe Shmoe")
      expect(all(".top_review")[1]).to have_content("Pretty goood!")
      expect(all(".top_review")[1]).to have_content("4 stars")
      expect(all(".top_review")[1]).to have_content("Joe Shmoe")
      expect(all(".top_review")[2]).to have_content("Decent")
      expect(all(".top_review")[2]).to have_content("3 stars")
      expect(all(".top_review")[2]).to have_content("Joe Shmoe")

    end
    it 'user sees bottom 3 reviews' do
      visit book_path(@book)

      expect(all(".bottom_review")[0]).to have_content("Uh...")
      expect(all(".bottom_review")[0]).to have_content("2 stars")
      expect(all(".bottom_review")[0]).to have_content("Joe Shmoe")
      expect(all(".bottom_review")[2]).to have_content("Pretty goood!")
      expect(all(".bottom_review")[2]).to have_content("4 stars")
      expect(all(".bottom_review")[2]).to have_content("Joe Shmoe")
      expect(all(".bottom_review")[1]).to have_content("Decent")
      expect(all(".bottom_review")[1]).to have_content("3 stars")
      expect(all(".bottom_review")[1]).to have_content("Joe Shmoe")
    end
    it 'user sees overall average rating' do
      visit book_path(@book)
      expect(page).to have_content('Average Rating - 3.5')
    end
  end
end
