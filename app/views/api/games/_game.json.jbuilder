json.id game.id
json.type game.type
if @user
    json.opponent do
        json.partial! 'api/users/user_basic', user: game.opponent(@user)
    end
else
    json.players(game.users) do |player|
        json.username player.username
        json.id player.id
    end
end
json.turn do
    json.username game.turn.user.username
    json.user_id game.turn.user.id
end
json.healths(game.healths) do |health|
    json.username health.user.username
    json.value health.value
end
if !game.active
    json.winner do
        json.user_id game.win.user.id
    end
end
json.singleScreen game.single_screen
json.numberOfTurns game.number_of_turns
json.healthPlayerOne game.health_player_1
json.healthPlayerTwo game.health_player_2