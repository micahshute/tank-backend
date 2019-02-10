class Win < ApplicationRecord
    belongs_to :game, polymorphic: true
    belongs_to :user
end
