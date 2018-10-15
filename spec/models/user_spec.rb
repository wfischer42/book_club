require 'rails_helper'

describe User, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'Relationship' do
    it { should have_many(:reviews) }
    it { should have_many(:books).through(:reviews)}
  end

  describe 'Instance Methods' do
    before(:each) do
      author = Author.create(name:"823uiahpfd")
      book = Book.create(title:"191209", authors: [author], pages: 12, year: 1928)

      @user = User.create(name:"oihnoic")
      @rev_1 = @user.reviews.create(title:"abcd", description:"asdf", book: book, rating: 1)
      @rev_2 = @user.reviews.create(title:"efgh", description:"qw4", book: book, rating: 2)
      @rev_3 = @user.reviews.create(title:"ijkl", description:"123wyg456", book: book, rating: 3)
    end
    it 'returns reviews in chronological order' do
      expect(@user.sorted_reviews("asc")[0]).to eq(@rev_1)
      expect(@user.sorted_reviews("asc")[1]).to eq(@rev_2)
      expect(@user.sorted_reviews("asc")[2]).to eq(@rev_3)
    end
  end
  describe 'Class Methods' do
    it 'returns top three users by number of reviews' do
      author = Author.create(name:"823uiahpfd")
      book = Book.create(title:"191209", authors: [author], pages: 12, year: 1928)
      book_2 = Book.create(title:"3434", authors: [author], pages: 12, year: 1928)
      book_3 = Book.create(title:"44449", authors: [author], pages: 12, year: 1928)

      user_1 = User.create(name:"Bob")
      user_2 = User.create(name:"Tod")
      user_3 = User.create(name:"Llama")

      user_1.reviews.create(title:"abcd", description:"asdf", book: book, rating: 1)
      user_2.reviews.create(title:"efgh", description:"qw4", book: book, rating: 2)
      user_2.reviews.create(title:"ijkl", description:"123wyg456", book: book_2, rating: 3)
      user_2.reviews.create(title:"asdfsd", description:"1asdfsdsdd", book: book_3, rating: 3)
      user_3.reviews.create(title:"efgh", description:"qw4", book: book, rating: 2)
      user_3.reviews.create(title:"ijkl", description:"123wyg456", book: book_2, rating: 3)

      expect(User.top_three_reviewers).to eq([user_2, user_3, user_1])
    end 
  end
end
