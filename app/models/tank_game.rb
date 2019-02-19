class TankGame < ApplicationRecord
    has_many :user_games, as: :game, inverse_of: :game
    has_many :users, through: :user_games
    has_many :healths, as: :game, dependent: :destroy, inverse_of: :game
    has_one :turn, as: :game, dependent: :destroy, inverse_of: :game
    has_one :win, as: :game, dependent: :destroy, inverse_of: :game


    validate :validate_users

    #MARK VALIDATIONS
    def validate_users
        errors.add(:users, "Must have 2 players") if users.length != 2
    end

    #MARK CLASS METHODS


    def self.new_singlescreen_game(player)
        game = new_game(player, player)
        game.single_screen = true
        game.save
        game
    end 
 

    def self.new_game(*players)
        raise ArgumentError.new("There must be 2 players in TankGame") if players.length != 2
        game = self.new()
        players.each do |p| 
            game.users << p 
            game.healths << Health.create(user: p, value: 100)
        end
        game.turn = Turn.create(user: players[0])
        begin
            game.save  
            return game
        rescue 
            return game
        end
    end

    def self.for_user(user)
       user.tank_games
    end

    #MARK INSTANCE METHODS

    def type
        self.class.to_s
    end

    def current_turn
        if single_screen
            return number_of_turns % 2 == 0 ? 'blue' : 'red'
        else
            return turn.player
        end
    end

    def active=(active_status)
        write_attribute(:active, active_status)
        if !active_status
            self.healths.destroy_all
            self.turn.destroy
        end
        self.save
    end

    def opponent(user)
        return nil if not has_user?(user)
        opponent = self.users.find { |u| u != user }
        return !!opponent ? opponent : user
    end

    def singlescreen_turn
        return self.number_of_turns % 2 == 0 ? "blue" : "red"
    end

    def singlescreen_user(user)
        return user.downcase == "blue" ? self.users[0] : self.users[1]
    end

    def register_hit(user, damage)
        if self.single_screen
            if user.downcase == "blue"
                self.health_player_1 = self.health_player_1 - damage
            else
                self.health_player_2  = self.health_player_2 - damage
            end
            @ending_user = singlescreen_user(singlescreen_turn)
            if self.health_player_1 <= 0 || self.health_player_2 <= 0
                self.active = false 
                return
            end
        else
            raise ArgumentError.new("User #{user.username} is not in this game") if not has_user?(user)
            health = healths.where(user: user)
            health.update(value: health.value - damage)
            if(health.value <= 0)
                active = false
                Win.create(game: self, user: self.opponent(user))
            end
            @ending_user = self.opponent(user)
        end
        self.end_turn(@ending_user)
    end

    def end_turn(user)
        raise ArgumentError.new("User #{user.username} is not in this game") if not has_user?(user)
        raise ArgumentError.new("It is not #{user.username}'s turn'") if turn.user.username != user.username
        self.turn.user = self.opponent(user) 
        self.number_of_turns = self.number_of_turns + 1
        self.save
        return true
    end

    #MARK SERIALIZER METHODS 

    def to_shallow_builder
        Jbuilder.new do |g|
            g.id id
            g.type self.class.to_s
        end
    end 

    def shallow_json
        to_shallow_builder.target!
    end

    def to_builder
        Jbuilder.new do |g|
            g.players self.users.map{ |u| u.json }
            g.type self.class.to_s
            g.id self.id
            g.health self.healths.map{ |h| h.json }
            g.turn self.turn.user.to_builder
        end
    end

    def json
        to_builder.target!.gsub("\\", "")
    end

    def builder_for_user(user)
        Jbuilder.new do |g|
            g.type self.class.to_s
            g.id self.id
            g.oppenent self.opponent.to_builder
            g.health Health.where(game: self, user: user).value
            g.turn turn.user.to_builder
        end
    end

    def json_for_user(user)
        builder_for_user(user).target!
    end


    private

    def has_user?(user)
        return self.users.include?(user)
    end 

end
