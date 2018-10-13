require 'rails_helper'

describe 'user deletes a review' do
  describe 'they link from the users show page' do
    it 'displays all users reviews without the deleted review' do

      book_1 = Book.create(title: "Huckleberry Finn", pages: 210, year: 1950)
      book_2 = Book.create(title: "Dune", pages: 900, year: 1950)
      user = User.create(name: "Joy Opinions")
      review_1 = user.reviews.create(title: "Joyful book", description: "This book brought joy to my life", rating: 4, book_id: book_1.id)
      review_2 = user.reviews.create(title: "No joy", description: "None of the joys were brought by reading this", rating: 2, book_id: book_2.id)

      visit user_path(user)
      within("#delete-#{review_1.id}") do
        click_link "Delete"
      end

      expect(current_path).to eq(user_path(user))
      expect(page).to have_content(review_2.description)
      expect(page).not_to have_content(review_1.description)
    end
  end
end
