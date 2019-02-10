json.games(@games) do |game|
    json.partial! "game", game: game
end