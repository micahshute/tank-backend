class Turn < ApplicationRecord
  belongs_to :game, polymorphic: true
  belongs_to :user

  def self.my_turn?(game: , player:)

  end

  def self.turn_for_game(game)
    Turn.where(game: game).user
  end
end
