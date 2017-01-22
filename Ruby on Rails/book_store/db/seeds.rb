# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email: 'admin@bookstore.pl', password: 'qwerty12', admin: true)
User.create(email: 'worker@bookstore.pl', password: 'qwerty12', worker: true)
User.create(email: 'user1@bookstore.pl', password: 'qwerty12')

20.times do
  Book.create(title: Faker::Book.title, author: Faker::Book.author, publisher: Faker::Book.publisher, genre: Faker::Book.genre, copies_count: rand(1..5))
end
