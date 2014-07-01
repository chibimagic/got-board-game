require 'sinatra'
require 'JSON'
require_relative 'lib/game.rb'

post '/games' do
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
  begin
    houses = data.map { |house, player_name| house_map[house].new(player_name) }
    g = Game.new(houses)
  rescue RuntimeError => e
    e.message
  end
end

get '/games/:game' do |game_id|
end
