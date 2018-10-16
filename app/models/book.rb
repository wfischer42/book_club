class Book < ApplicationRecord
  validates_presence_of :title, :year, :pages

  has_many :reviews, dependent: :delete_all
  has_many :users, through: :reviews, dependent: :nullify

  has_many :book_authors, dependent: :nullify

  has_many :authors, through: :book_authors, dependent: :nullify

  def self.with_avg_rating(sort_dir, sort_by)
    books = select('books.*, CASE WHEN count(reviews.rating) = 0 THEN 0 ELSE avg(reviews.rating) END AS avg_rating, count(reviews) AS rev_count')
    .left_outer_joins(:reviews)
    .group(:id, :book_id)
    if sort_dir && sort_by
      books = books.order("#{sort_by} #{sort_dir}")
    end
    books
  end

  def self.get_three(sort_dir, sort_by)
    books = select('books.*, avg(rating) AS avg_rating, count(reviews) AS rev_count')
    .joins(:reviews)
    .group(:id, :book_id)
    books = books.order("#{sort_by} #{sort_dir}")
  end

  def self.destroy_books_with_single_author(author_id)
    books = select('books.*, count(DISTINCT book_authors) AS auth_count')
    .joins(:book_authors)
    .group(:id, :book_id)
    .having('count(book_authors) = 1')
    .where("books.id IN (SELECT book_authors.book_id FROM book_authors WHERE author_id = ?)", author_id)
    .pluck(:id)

    destroy(books)
  end

  def top_3_reviews
    reviews.order(rating: :DESC).take(3)
  end

  def bottom_3_reviews
    reviews.order(rating: :ASC).take(3)
  end

  def average_rating
    avg_rating = reviews.average(:rating)
    avg_rating = 0 unless avg_rating
    avg_rating.round(1)
  end

  def other_authors(author)
    list = authors.map do |a|
      a if a.name != author.name
    end
    list.compact
  end

  def best_review
    reviews.order(rating: :DESC).first
  end
end
