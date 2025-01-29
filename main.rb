require './game.rb'
require './random_player.rb'
require './your_player.rb'
require './helper.rb'

require './brain.rb'
require 'pry'

srand(129)

grid_size = 10
number_of_player = 2

your_strategy = -> {
  game = Game.new(grid_size: grid_size)
  Brain.game = game

  number_of_player.times.each.with_index(1) do |_,i|
    your_player = YourPlayer.new(game: game, name: "Candidate[#{i}]")
    game.add_player(your_player)
  end

  game.start
}

random_strategy = -> {
  game = Game.new(grid_size: grid_size)

  random_player = RandomPlayer.new(game: game, name: 'Rando 1')
  random_player2 = RandomPlayer.new(game: game, name: 'Rando 2')

  game.add_player(random_player)
  game.add_player(random_player2)

  game.start
}

random_results = random_strategy.call
your_results = your_strategy.call

compare_hashes(your_results, random_results)
# print_one_hash(your_results)
