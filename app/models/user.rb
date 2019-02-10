class User < ApplicationRecord

    has_secure_password
    has_many :user_games, dependent: :destroy
    has_many :tank_games, through: :user_games, source: :game, source_type: "TankGame"
    has_many :wins 

    #MARK VALIDATIONS 

    validates_uniqueness_of :username

    #MARK INSTANCE METHODS

    def games
        return tank_games
    end

    def active_games 
        games.where(active: true)
    end

    def number_of_games
        return self.games.length
    end

    def number_of_active_games
        return self.active_games.length
    end

    def won_games
        return wins.map{ |w| w.game }
    end

    def number_of_won_games
        return wins.length
    end

    #MARK SERIALIZATION METHODS

    def to_builder
        return Jbuilder.new do |u|
            u.(self, :username, :id)
        end
    end

    def json
        to_builder.target!
    end

    def full_json
        Jbuilder.new do |u|
            u.username username
            u.id id
            u.games games.map{ |g| g.shallow_json }
        end
    end


end
