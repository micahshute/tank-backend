class Game

    VALID_TYPES = [
        :tank_games
    ]

    def self.valid?(type)
        VALID_TYPES.include?(type.to_s.downcase.to_sym)
    end

end