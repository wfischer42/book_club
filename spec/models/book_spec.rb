require 'rails_helper'

describe Book, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:pages) }
    it { should validate_presence_of(:year) }
  end

  describe 'Relationship' do
    it { should have_many(:reviews) }
    it { should have_many(:users).through(:reviews)}
    it { should have_many(:book_authors) }
    it { should have_many(:authors).through(:book_authors) }
  end

  describe 'Instance Methods' do
    it 'can return average rating' do
      book_1 = Book.create(title: "Huckleberry Finn", pages: 250, year: 1950)
      author = book_1.authors.create(name: "Mark Twain")
      user = User.create(name: "Joe Shmoe")
      book_1.reviews.create(title: "Awesome book!", description: "This book is totally awesome", rating: 5, user_id: user.id)
      book_1.reviews.create(title: "Crappiest book", description: "This book is terrible", rating: 1, user_id: user.id)

      expect(book_1.average_rating).to eq(3)
    end
  end
end
