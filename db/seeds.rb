# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


def get_authors
  new_authors = []
  number_of_authors = rand(1..8)
  if number_of_authors > 5
    number_of_authors -= 5
  else
    number_of_authors = 1
  end
  number_of_authors.times do
    new_author = get_author
    new_authors << new_author if new_author
  end
  new_authors
end

def get_author
  if rand(1..3) < 3
    return @authors.sample
  else
    auth = @authors.pop
    return auth
  end
end

30.times do
  name_type = rand(1..2)
  Author.create(name: Faker::FunnyName.unique.three_word_name) if name_type == 1
  Author.create(name: Faker::FunnyName.unique.two_word_name) if name_type == 2
end

@authors = Author.all.to_a.shuffle

until @authors.count == 0
  authors = get_authors
  new_book = Book.create(title: Faker::Book.unique.title, pages: rand(97..800), year: rand(1910..2018), authors: authors)
end

30.times do
  User.create(name: Faker::FunnyName.unique.two_word_name)
end

User.all.each do |user|
  number_of_reviews = rand(1..5)
  number_of_reviews.times do
    book = Book.all.sample
    title = Faker::Lorem.sentence(1, true, 3)
    description = Faker::Lorem.paragraph(2, true, 3)
    review = user.reviews.create(title: title, description: description, book: book, rating: rand(1..5))
  end
end
