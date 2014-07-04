require 'sinatra'
require 'JSON'
require_relative 'lib/game.rb'
require_relative 'lib/storage.rb'

# Start a new game
post '/games' do
  begin
    request.body.rewind
    data = JSON.parse(request.body.read)
    house_map = {
      'Stark' => HouseStark,
      'Lannister' => HouseLannister,
      'Baratheon' => HouseBaratheon,
      'Greyjoy' => HouseGreyjoy,
      'Tyrell' => HouseTyrell,
      'Martell' => HouseMartell,
    }
    houses = data.map { |house, player_name| house_map[house].new(player_name) }
    g = Game.new(houses)
    game_id = Storage.save_game(nil, g)
    { :game_id => game_id }.to_json
  rescue JSON::ParserError => e
    'JSON input expected'
  rescue RuntimeError => e
    e.message
  end
end

# See information about an existing game
get '/games/:game' do |game_id|
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
