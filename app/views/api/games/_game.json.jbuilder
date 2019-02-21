json.id game.id
json.type game.type
json.active game.active
if @user
    json.opponent do
        json.partial! 'api/users/user_basic', user: game.opponent(@user)
        json.player (game.players.first == @user ? 2 : 1)
    end
else
    json.players(game.players) do |player|
        json.username player.username
        json.id player.id
    end
end

if !game.single_screen
    if !game.active
        json.winner do
            json.user_id game.win.user.id
            json.username game.win.user.username
        end
    end   
    json.turn do
        json.username game.turn.user.username 
        json.user_id game.turn.user.id
        json.player ( game.players.index{ |p| p.username == game.turn.user.username } + 1 )
    end
    json.healths(game.healths) do |health|
        json.username health.user.username
        json.value health.value
    end
end
json.singleScreen game.single_screen
json.numberOfTurns game.number_of_turns
json.healthPlayerOne game.health_player_1
json.healthPlayerTwo game.health_player_2