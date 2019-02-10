class UserGame < ApplicationRecord
    belongs_to :game, polymorphic: :true, inverse_of: :user_game
    belongs_to :user

end