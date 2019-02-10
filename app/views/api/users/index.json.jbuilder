json.users(@users) do |user|
    json.id user.id
    json.username user.username
    json.active_games user.number_of_active_games
    json.games_won user.number_of_won_games

end