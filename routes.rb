require 'sinatra'
require 'json'
require_relative 'lib/controllers/game_controller.rb'
require_relative 'lib/controllers/storage_controller.rb'

enable :sessions
set :session_secret, 'got-board-game'
set :raise_errors, false
set :show_exceptions, false

# Routes that don't require authentication
UNPROTECTED_ROUTES = [
  ['post', '/session'],
  ['post', '/users']
]

def validate_constants(class_strings, expected_class)
  begin
    class_strings.each do |class_string|
      actual_class = class_string.constantize
      unless actual_class < expected_class
        raise NameError.new(actual_class.to_s + ' is not a ' + expected_class.to_s, actual_class.to_s)
      end
    end
  rescue NameError => e
    raise e.name + ' is not a valid ' + expected_class.to_s
  end
end

before do
  if request.post?
    begin
      request.body.rewind
      @data = JSON.parse(request.body.read)
    rescue JSON::ParserError => e
      halt('JSON input expected')
    end
  end

  route = [request.request_method.downcase, request.path_info]
  unless UNPROTECTED_ROUTES.include?(route)
    session_id = session['session_id']
    @username = StorageController.get_user_for_session(session_id)
  end
end

before '/games/:game/?:path?' do |game_id, path|
  games = StorageController.list_games(@username)
  game = games.find { |game| game[:game_id] == game_id.to_i }
  if game.nil?
    halt(@username.to_s + ' does not have access to ' + game_id.to_s)
  end
  @game = StorageController.get_game(game_id)
  @house_class = game[:house]
end

after '/games/:game/:path?' do |game_id, path|
  if request.post?
    StorageController.save_game(game_id, @game)
  end
end

error do
  e = env['sinatra.error']
  headers 'Content-Type' => 'text/plain'
  body e.message
end

# Get information about your current session
get '/session' do
  { :username => @username, :session_id => session['session_id'] }.to_json
end

# Log in
# Body: {"username":"jdoe","password":"password"}
post '/session' do
  if !@data['username'] || !@data['password']
    raise 'Format: {"username":"jdoe","password":"password"}'
  end
  username = @data['username']
  password = @data['password']
  session_id = session['session_id']
  if StorageController.correct_password?(username, password)
    StorageController.create_session(username, session_id)
    { :username => username, :session_id => session_id }.to_json
  else
    raise 'Incorrect username or password'
  end
end

# List existing users
get '/users' do
  StorageController.list_users.to_json
end

# Create a user
# Body: {"username":"jdoe","password":"password","player_name":"John"}
post '/users' do
  if !@data['username'] || !@data['password'] || !@data['player_name']
    raise 'Format: {"username":"jdoe","password":"password","player_name":"John"}'
  end
  username = @data['username']
  password = @data['password']
  player_name = @data['player_name']
  StorageController.create_user!(username, password, player_name)
  { :username => username, :player_name => player_name }.to_json
end

# See information about an existing user
get '/users/:username' do |username|
  StorageController.get_user(username).to_json
end

# Delete a user
delete '/users/:username' do |username|
  unless @username == username
    raise 'Cannot delete another user'
  end

  StorageController.delete_user(username)
end

# List existing games
get '/games' do
  StorageController.list_games(@username).to_json
end

# Start a new game
# Body: {"HouseStark":"jdoe","HouseLannister":"jsmith","HouseBaratheon":"jjones"} or ["jdoe","jsmith","jjames"]
post '/games' do
  if @data.is_a?(Hash)
    validate_constants(@data.keys, House)
    house_classes_to_usernames = @data.map { |house_class_string, username| [house_class_string.constantize, username] }.to_h
  elsif @data.is_a?(Array)
    random_house_classes = Game.allowed_house_classes_for_players(@data.length).shuffle
    house_classes_to_usernames = random_house_classes.map.with_index { |house_class, i| [house_class, @data[i]] }.to_h
  end

  unless house_classes_to_usernames.has_value?(@username)
    raise 'Cannot create a game that does not include yourself: ' + @username.to_s + ', ' + @data.to_s
  end
  g = Game.create_new(house_classes_to_usernames.keys)

  houses = [HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy, HouseTyrell, HouseMartell]
  house_usernames = houses.map do |house_class|
    username = house_classes_to_usernames.fetch(house_class, nil)
  end
  game_id = StorageController.create_game(g, *house_usernames)
  { :game_id => game_id }.to_json
end

# See information about an existing game
get '/games/:game' do |game_id|
  game_info = @game.serialize
  if game_info[:game_stack].last == :assign_orders
    game_info[:houses].each do |house, house_info|
      house_info[:tokens].delete_if { |token| token.keys[0].constantize < OrderToken }
    end
    game_info[:map][:areas].each do |area, tokens|
      tokens.delete_if { |token| token.keys[0].constantize < OrderToken }
    end
  end
  game_info.delete(:wildling_deck)
  game_info.delete(:westeros_deck_i)
  game_info.delete(:westeros_deck_ii)
  game_info.delete(:westeros_deck_iii)
  game_info.to_json
end

# Place orders, execute orders, replace orders with Messenger Raven token
# Body: {"CastleBlack":"WeakMarchOrder","DragonstonePortToShipbreakerBay":"SpecialRaidOrder"}
post '/games/:game/orders' do |game_id|
  validate_constants(@data.keys, Area)
  validate_constants(@data.values, OrderToken)
  orders = @data.map { |area_class_string, order_class_string| [area_class_string.constantize, order_class_string.constantize] }.to_h
  orders.each { |area_class, order_class| @game.place_order!(@house_class, area_class, order_class) }
  { :game_id => game_id }.to_json
end

# Muster troops
# Body: {"Winterfell":[{"muster":"Knight"}],"Seagard":[{"upgrade":"Ship"},{"muster":"Footman"}]}
post '/games/:game/muster' do |game_id|
end

# Bid on influence track or wildling attack
# Body: 4
post '/games/:game/bid' do |game_id|
  unless @data.is_a?(Integer)
    raise 'Format: 4'
  end
  @game.bid!(@house_class, @data)
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
