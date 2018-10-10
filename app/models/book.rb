class Book < ApplicationRecord
  validates_presence_of :title, :year, :pages

  has_many :reviews
  has_many :users, through: :reviews

  has_many :book_authors
  has_many :authors, through: :book_authors

  def self.with_avg_rating(sort_dir)
    books = select('books.*, avg(rating) AS avg_rating')
    .joins(:reviews)
    .group(:id, :book_id)
    if sort_dir
      books = books.order("avg_rating #{sort_dir}")
    end
    books
  end

  def average_rating
    reviews.average(:rating)
  end
end
