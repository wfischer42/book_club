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

  describe ' Class Methods' do
      before(:each) do
        @book_1 = Book.create(title: "Huckleberry Finn", pages: 210, year: 1950)
        @author_1 =@book_1.authors.create(name: "Mark Twain")
        user = User.create(name: "Joe Shmoe")
        @book_1.reviews.create(title: "Awesome book!", description: "This book is totally awesome", rating: 5, user_id: user.id)
        @book_1.reviews.create(title: "Crappiest book", description: "This book is terrible", rating: 1, user: user)

        @book_2 = Book.create(title: "Dune", pages: 900, year: 1950)
        @book_2.authors << @author_1
        @book_2.reviews.create(title: "Worst book!", description: "This book is awful", rating: 1, user_id: user.id)

        @book_3 = Book.create(title: "Pride and Prejudice", pages: 130, year: 1950)
        author_2 = @book_3.authors.create(name: "Jane Austen")
        @book_3.reviews.create(title: "Awesome book!", description: "This book is super great!", rating: 5, user_id: user.id)
        @book_3.reviews.create(title: "Uh...", description: "I don't get it.", rating: 5, user_id: user.id)
        @book_3.reviews.create(title: "Best book evaarrr!", description: "This book is super great!", rating: 5, user_id: user.id)
      end
    it 'sorts books by average rating in ascending order' do
      expect(Book.with_avg_rating("ASC", "avg_rating")).to eq([@book_2, @book_1, @book_3])
    end
    it 'sorts books by average rating in descending order' do
      expect(Book.with_avg_rating("DESC", "avg_rating")).to eq([@book_3, @book_1, @book_2])
    end
    it 'destroys all books associated with only one author that is deleted' do
      expect(Book.destroy_books_with_single_author(@author_1.id)).to contain_exactly(@book_1, @book_2)
    end
  end

  describe ' Instance Methods' do
      before(:each) do
        @book_1 = Book.create(title: "Huckleberry Finn", pages: 210, year: 1950)
        @author_1 =@book_1.authors.create(name: "Mark Twain")
        user = User.create(name: "Joe Shmoe")
        @author_2 = @book_1.authors.create(name: "Ghost Writer")
        @review_1 = @book_1.reviews.create(title: "Awesome book!", description: "This book is totally awesome", rating: 5, user_id: user.id)
        @review_2 = @book_1.reviews.create(title: "Crappiest book", description: "This book is terrible", rating: 1, user: user)
        @review_3 = @book_1.reviews.create(title: "It's fine", description: "I like it, mas o menos", rating: 2, user: user)
        @review_4 = @book_1.reviews.create(title: "Pretty good!", description: "Not the best but pretty good", rating: 4, user: user)
      end
    it 'returns top_3_reviews' do
      expect(@book_1.top_3_reviews).to eq([@review_1, @review_4, @review_3])
    end
    it 'returns bottom_3_reviews' do
      expect(@book_1.bottom_3_reviews).to eq([@review_2, @review_3, @review_4])
    end
    it 'returns an average rating' do
      expect(@book_1.average_rating).to eq(3.0)
    end
    it 'returns the best review' do
      expect(@book_1.best_review).to eq(@review_1)
    end
    it 'returns all authors besides the one passed in' do
      book = Book.create(title: "Americanah", pages: 340, year: 2014)
      author = book.authors.create(name: "Chimamandah Ngozi")
      expect(@book_1.other_authors(@author_1)).to eq([@author_2])
      expect(book.other_authors(author)).to eq([])
    end
  end
end
