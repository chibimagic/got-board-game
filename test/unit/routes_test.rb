class RoutesTest < MiniTest::Test
  def setup
    @browser = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
    @usernames = ['a', 'b', 'c', 'd', 'e', 'f']
    @usernames.each do |username|
      @browser.post('/users', { 'username' => username, 'password' => 'password', 'player_name' => username }.to_json)
    end
    @browser.post('/session', { 'username' => @usernames[0], 'password' => 'password' }.to_json)
  end

  def test_create_user_invalid
    response = @browser.post('/users', '')
    assert_equal('JSON input expected', response.body)
    response = @browser.post('/users', { 'username' => 'username' }.to_json)
    assert_equal('Format: {"username":"jdoe","password":"password","player_name":"John"}', response.body)
    response = @browser.post('/users', { 'password' => 'password' }.to_json)
    assert_equal('Format: {"username":"jdoe","password":"password","player_name":"John"}', response.body)
    response = @browser.post('/users', { 'player_name' => 'player name' }.to_json)
    assert_equal('Format: {"username":"jdoe","password":"password","player_name":"John"}', response.body)
  end

  def test_get_session
    response = @browser.get('/session')
    session_info = JSON.parse(response.body)
    assert_equal('a', session_info['username'])
  end

  def test_session_invalid
    browser2 = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
    response = browser2.get('/session')
    assert_match(/^No user with session id: /, response.body)
  end

  def test_login_invalid
    response = @browser.post('/session', { 'username' => 'a' }.to_json)
    assert_equal('Format: {"username":"jdoe","password":"password"}', response.body)
    response = @browser.post('/session', { 'username' => 'a', 'password' => 'a' }.to_json)
    assert_equal('Incorrect username or password', response.body)
  end

  def test_list_users
    response = @browser.get('/users')
    assert_equal('["a","b","c","d","e","f"]', response.body)
  end

  def test_user_info
    response = @browser.get('/users/a')
    assert_equal('{"username":"a","player_name":"a"}', response.body)
  end

  def test_user_info_invalid
    response = @browser.get('/users/z')
    assert_equal('No user with username: z', response.body)
  end

  def test_create_delete_user
    browser2 = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
    response = browser2.post('/users', { 'username' => 'my_username', 'password' => 'my_password', 'player_name' => 'my_player_name' }.to_json)
    parsed = JSON.parse(response.body)
    assert_equal(2, parsed.keys.count)
    assert_equal('my_username', parsed['username'])
    assert_equal('my_player_name', parsed['player_name'])

    browser2.post('/session', { 'username' => 'my_username', 'password' => 'my_password' }.to_json)

    response = browser2.delete('/users/my_username')
    assert_equal(200, response.status)
    assert_equal('', response.body)
  end

  def test_delete_other_user
    response = @browser.delete('/users/f')
    assert_equal('Cannot delete another user', response.body)
  end

  def test_create_game_invalid
    response = @browser.post('/games', '')
    assert_equal('JSON input expected', response.body)
    response = @browser.post('/games', {}.to_json)
    assert_equal('Cannot create a game that does not include yourself: a, {}', response.body)
    response = @browser.post('/games', { 'HouseStark' => 'b' }.to_json)
    assert_equal('Cannot create a game that does not include yourself: a, {"HouseStark"=>"b"}', response.body)
    response = @browser.post('/games', { 'HouseStark' => 'a', 'HouseLannister' => 'b', 'HouseBaratheon' => 'z' }.to_json)
    assert_equal('No user with username: z', response.body)
    response = @browser.post('/games', { 'HouseStark' => 'a' }.to_json)
    assert_equal('Cannot play A Game of Thrones (second edition) with 1 player', response.body)
    response = @browser.post('/games', { 'HouseStark' => 'a', 'HouseLannister' => 'b' }.to_json)
    assert_equal('Cannot play A Game of Thrones (second edition) with 2 players', response.body)
  end

  def test_create_game_random
    response = @browser.post('/games', ['a', 'b', 'c'].to_json)
    game_id = JSON.parse(response.body)['game_id']
    response = @browser.get('/games/' + game_id.to_s)
    assert_equal(true, Utility.valid_json?(response.body))
  end

  def test_create_retrieve
    response = @browser.post('/games', { 'HouseStark' => 'a', 'HouseLannister' => 'b', 'HouseBaratheon' => 'c' }.to_json)
    game_id = JSON.parse(response.body)['game_id']
    response = @browser.get('/games/' + game_id.to_s)
    assert_equal(true, Utility.valid_json?(response.body))
  end

  def test_game_access
    response = @browser.post('/games', { 'HouseStark' => 'a', 'HouseLannister' => 'a', 'HouseBaratheon' => 'a' }.to_json)
    a_game_id = JSON.parse(response.body)['game_id']

    browser2 = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
    response = browser2.post('/session', { 'username' => 'b', 'password' => 'password' }.to_json)
    response = browser2.post('/games', { 'HouseStark' => 'b', 'HouseLannister' => 'b', 'HouseBaratheon' => 'b' }.to_json)
    b_game_id = JSON.parse(response.body)['game_id']

    a_games = JSON.parse(@browser.get('/games').body)
    b_games = JSON.parse(browser2.get('/games').body)
    a_game_ids = a_games.map { |game| game['game_id'] }
    b_game_ids = b_games.map { |game| game['game_id'] }
    assert_includes(a_game_ids, a_game_id)
    assert_includes(b_game_ids, b_game_id)
    refute_includes(a_game_ids, b_game_id)
    refute_includes(b_game_ids, a_game_id)

    response = @browser.get('/games/' + a_game_id.to_s)
    assert_equal(true, Utility.valid_json?(response.body))
    response = browser2.get('/games/' + a_game_id.to_s)
    assert_equal('b does not have access to ' + a_game_id.to_s, response.body)
    response = @browser.get('/games/' + b_game_id.to_s)
    assert_equal('a does not have access to ' + b_game_id.to_s, response.body)
    response = browser2.get('/games/' + b_game_id.to_s)
    assert_equal(true, Utility.valid_json?(response.body))
  end

  def test_place_orders
    response = @browser.post('/games', { 'HouseStark' => 'a', 'HouseLannister' => 'b', 'HouseBaratheon' => 'c' }.to_json)
    game_id = JSON.parse(response.body)['game_id']
    response = @browser.post('/games/' + game_id.to_s + '/orders', { 'AreaThatDoesntExist' => 'MarchOrder' }.to_json)
    assert_equal('AreaThatDoesntExist is not a valid Area', response.body)
    response = @browser.post('/games/' + game_id.to_s + '/orders', { 'CastleBlack' => 'OrderTokenThatDoesntExist' }.to_json)
    assert_equal('OrderTokenThatDoesntExist is not a valid Order Token', response.body)
    response = @browser.post('/games/' + game_id.to_s + '/orders', { 'MarchOrder' => 'CastleBlack' }.to_json)
    assert_equal('March Order is not a valid Area', response.body)
    response = @browser.post('/games/' + game_id.to_s + '/orders', { 'CastleBlack' => 'HouseStark' }.to_json)
    assert_equal('House Stark is not a valid Order Token', response.body)
    response = @browser.post('/games/' + game_id.to_s + '/orders', { 'CastleBlack' => 'MarchOrder' }.to_json)
    assert_equal('Cannot place March Order (House Stark) because Castle Black (0) has no units', response.body)
    response = @browser.post('/games/' + game_id.to_s + '/orders', { 'Lannisport' => 'MarchOrder' }.to_json)
    assert_equal('Cannot place March Order (House Stark) because Lannisport (3) is controlled by House Lannister', response.body)
    response = @browser.post('/games/' + game_id.to_s + '/orders', { 'TheShiveringSea' => 'WeakMarchOrder', 'WhiteHarbor' => 'MarchOrder', 'Winterfell' => 'DefenseOrder' }.to_json)
    assert_equal(true, Utility.valid_json?(response.body))
  end

  def teardown
    @usernames.each do |username|
      @browser.post('/session', { 'username' => username, 'password' => 'password' }.to_json)
      @browser.delete('/users/' + username)
    end
  end
end
