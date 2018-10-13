class BookAuthor < ApplicationRecord
  belongs_to :book
  belongs_to :author

  def self.book_ids_with_single_author(author_id)
    # a = select(:book_id)
    # .where(author_id: author_id)
    # .group(:id, :book_id)
    # .having('count(book_id) = 1')
    # .pluck(:book_id)
    a = select('book_id, count(authors) AS asdf').where(author_id: author_id).group(:id, :book_id).having('count(author_id) = 1')
    binding.pry
  end
end
