class User < ApplicationRecord
  validates_presence_of :name

  has_many :reviews
  has_many :books, through: :reviews

  def self.top_three_reviewers
    select('users.*, count(reviews) AS review_count')
    .joins(:reviews).group(:id, :user_id).order("review_count DESC").take(3)
  end
end
