class Book < ApplicationRecord
  validates_presence_of :title, :year, :pages

  has_many :reviews
  has_many :users, through: :reviews

  has_many :book_authors
  has_many :authors, through: :book_authors
end
