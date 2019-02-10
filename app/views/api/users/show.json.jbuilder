json.(@user, :username, :id)
json.games(@user.games) do |game|
    json.partial! 'api/games/game', game: game
end
json.games_won @user.number_of_won_games
json.active_games @user.number_of_active_games