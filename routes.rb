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

# List existing users
get '/users' do
  Storage.list_users.to_json
end

# Create a user
# Body: {"username":"jdoe","password":"password","player_name":"John"}
post '/users' do
  begin
    username = @data['username']
    password = @data['password']
    player_name = @data['player_name']
    Storage.create_user(username, password, player_name).to_json
  rescue RuntimeError => e
    e.message
  end
end

# See information about an existing user
get '/users/:username' do
  Storage.get_user(username).to_json
end

# List existing games
get '/games' do
  Storage.list_games.to_json
end

# Start a new game
# Body: {"HouseStark":"Alice","HouseLannister":"Bob","HouseBaratheon":"Carol"}
post '/games' do
  begin
    houses = @data.map { |house_class_string, player_name| house_class_string.constantize.create_new(player_name) }
    g = Game.create_new(houses)
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

# Place orders, execute orders, replace orders with Messenger Raven token
# Body: {"CastleBlack":"WeakMarchOrder","DragonstonePortToShipbreakerBay":"SpecialRaidOrder"}
post '/games/:game/orders' do |game_id|
end

# Muster troops
# Body: {"Winterfell":[{"muster":"Knight"}],"Seagard":[{"upgrade":"Ship"},{"muster":"Footman"}]}
post '/games/:game/muster' do |game_id|
end

# Bid on influence track or wildling attack
# Body: 4
post '/games/:game/bid' do |game_id|
end

# Use Valyrian Steel Blade token
# Body: none
post '/games/:game/combat' do |game_id|
end

# Use Messenger Raven token to see the top card of the wildling deck
get '/games/:game/wildling_deck' do |game_id|
end

# Use Messenger Raven token to replace card in wildling deck
# Body: top
# Body: bottom
post '/games/:game/wildling_deck' do |game_id|
end
