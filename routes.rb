require 'sinatra'
require 'JSON'
require_relative 'lib/game.rb'
require_relative 'lib/storage.rb'

enable :sessions
set :session_secret, 'got-board-game'

# Routes that don't require authentication
UNPROTECTED_ROUTES = [
  ['post', '/session'],
  ['post', '/users']
]

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
    begin
      @username = Storage.get_user_for_session(session_id)
    rescue RuntimeError => e
      halt(e.message)
    end
  end
end

before '/games/:game/?:path?' do |game_id, path|
  games = Storage.list_games(@username)
  game = games.find { |game| game[:game_id] == game_id.to_i }
  if game.nil?
    halt(@username.to_s + ' does not have access to ' + game_id.to_s)
  end
  @game = Storage.get_game(game_id)
  @house_class = game[:house]
end

# Get information about your current session
get '/session' do
  { :username => @username, :session_id => session['session_id'] }.to_json
end

# Log in
# Body: {"username":"jdoe","password":"password"}
post '/session' do
  begin
    if !@data['username'] || !@data['password']
      raise 'Format: {"username":"jdoe","password":"password}'
    end
    username = @data['username']
    password = @data['password']
    session_id = session['session_id']
    if Storage.correct_password?(username, password)
      Storage.create_session(username, session_id)
      { :username => username, :session_id => session_id }.to_json
    else
      raise 'Incorrect username or password'
    end
  rescue RuntimeError => e
    e.message
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
    if !@data['username'] || !@data['password'] || !@data['player_name']
      raise 'Format: {"username":"jdoe","password":"password","player_name":"John"}'
    end
    username = @data['username']
    password = @data['password']
    player_name = @data['player_name']
    Storage.create_user(username, password, player_name)
    { :username => username, :player_name => player_name }.to_json
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
  Storage.list_games(@username).to_json
end

# Start a new game
# Body: {"HouseStark":"jdoe","HouseLannister":"jsmith","HouseBaratheon":"jjones"}
post '/games' do
  begin
    unless @data.has_value?(@username)
      raise 'Cannot create a game that does not include yourself: ' + @username.to_s + ', ' + @data.to_s
    end
    houses = @data.map do |house_class_string, username|
      user = Storage.get_user(username)
      if user.nil?
        raise 'Cannot find user with username: ' + username
      end
      house_class_string.constantize.create_new(user[:player_name])
    end
    g = Game.create_new(houses)

    houses = [HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy, HouseTyrell, HouseMartell]
    house_usernames = houses.map do |house_class|
      username = @data.fetch(house_class.name, nil)
    end
    game_id = Storage.create_game(g, *house_usernames)
    { :game_id => game_id }.to_json
  rescue RuntimeError => e
    e.message
  end
end

# See information about an existing game
get '/games/:game' do |game_id|
  @game.serialize.to_json
end

# Place orders, execute orders, replace orders with Messenger Raven token
# Body: {"CastleBlack":"WeakMarchOrder","DragonstonePortToShipbreakerBay":"SpecialRaidOrder"}
post '/games/:game/orders' do |game_id|
  begin
    orders = Hash[@data.map { |area_class_string, order_class_string| [area_class_string.constantize, order_class_string.constantize] }]
    @game.place_orders(@house_class, orders)
    { :game_id => game_id }.to_json
  rescue RuntimeError => e
    e.message
  end
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
