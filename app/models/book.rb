class Book < ApplicationRecord
  validates_presence_of :title, :year, :pages

  has_many :reviews, dependent: :delete_all
  has_many :users, through: :reviews, dependent: :nullify

  has_many :book_authors, dependent: :nullify
  has_many :authors, through: :book_authors, dependent: :nullify

  def self.with_avg_rating(sort_dir, sort_by)
    books = select('books.*, avg(rating) AS avg_rating, count(reviews) AS rev_count')
    .joins(:reviews)
    .group(:id, :book_id)
    if sort_dir && sort_by
      books = books.order("#{sort_by} #{sort_dir}")
    end
    books
  end

  def top_3_reviews
    reviews.order(rating: :DESC).take(3)
  end

  def bottom_3_reviews
    reviews.order(rating: :ASC).take(3)
  end

  def average_rating
    reviews.average(:rating)
  end

  def other_authors(author)
    list = authors.map do |a|
      a.name if a.name != author.name
    end
    list.compact
  end

  def best_review
    reviews.order(rating: :DESC).first
  end
end
