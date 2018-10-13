class Book < ApplicationRecord
  validates_presence_of :title, :year, :pages

  has_many :reviews
  has_many :users, through: :reviews

  has_many :book_authors, dependent: :nullify
  has_many :authors, through: :book_authors

  def self.with_avg_rating(sort_dir, sort_by)
    books = select('books.*, avg(rating) AS avg_rating, count(reviews) AS rev_count')
    .joins(:reviews)
    .group(:id, :book_id)
    if sort_dir && sort_by
      books = books.order("#{sort_by} #{sort_dir}")
    end
    books
  end

  def self.destroy_books_with_single_author(author_id)
    # FIXME: This section updates count when it runs the where, so it
    # undoes the original filter and keeps only the books with one instance
    # of the same author. How to fix? Beats me.
    books = select('books.*, count(DISTINCT book_authors) AS auth_count')
    .joins(:book_authors)
    .group(:id, :book_id)
    .having('count(book_authors) = 1')

    books = books.scoping do
      where('book_authors.author_id = ?', author_id)
    end
    destroy(books_to_delete)
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
