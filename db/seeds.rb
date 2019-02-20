# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
m = User.create(username: "micahshute", password: "password")
k = User.create(username: "nee", password: "password")
tg = TankGame.new_game(m, k)
g = TankGame.new_singlescreen_game(m)
g1 = TankGame.new_singlescreen_game(m)
3.times do g1.register_hit('blue', 1) end
g.register_hit('red', 1)