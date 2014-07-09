require 'sinatra'
require 'JSON'
require_relative 'lib/game.rb'
require_relative 'lib/storage.rb'

before do
  if request.request_method == 'POST'
    begin
      request.body.rewind
      @data = JSON.parse(request.body.read)
    rescue JSON::ParserError => e
      halt('JSON input expected')
    end
  end
end

# List existing games
get '/games' do
  Storage.list_games.to_json
end

# Start a new game
post '/games' do
  begin
    houses = @data.map { |house_string, player_name| Houses.get_house_class(house_string).new(player_name) }
    g = Game.new_game(houses)
    game_id = Storage.save_game(nil, g)
    { :game_id => game_id }.to_json
  rescue RuntimeError => e
    e.message
  end
end

# See information about an existing game
get '/games/:game' do |game_id|
  Storage.get_game(game_id).serialize.to_json
end

# Place orders, execute orders
post '/games/:game/orders' do |game_id|
end

# Muster troops
post '/games/:game/muster' do |game_id|
end

# Bid on influence track or wildling attack
post '/games/:game/bid' do |game_id|
end

# Use Valyrian Steel Blade token
post '/games/:game/combat' do |game_id|
end

# Use Messenger Raven token to see the top card of the wildling deck
get '/games/:game/wildling_deck' do |game_id|
end

# Use Messenger Raven token to replace card in wildling deck
post '/games/:game/wildling_deck' do |game_id|
end
