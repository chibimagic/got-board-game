class TestRoutes < MiniTest::Test
  def valid_json?(json)
    begin
      JSON.parse(json)
      return true
    rescue JSON::ParserError
      return false
    end
  end

  def setup
    @browser = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
    usernames = ['a', 'b', 'c', 'd', 'e', 'f']
    usernames.each do |username|
      @browser.post('/users', { 'username' => username, 'password' => 'password', 'player_name' => username }.to_json)
    end
    @browser.post('/session', { 'username' => usernames[0], 'password' => 'password' }.to_json)
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

  def test_create_game_invalid
    response = @browser.post('/games', '')
    assert_equal('JSON input expected', response.body)
    response = @browser.post('/games', {}.to_json)
    assert_equal('Cannot create a game that does not include yourself: a, {}', response.body)
    response = @browser.post('/games', { 'HouseStark' => 'b' }.to_json)
    assert_equal('Cannot create a game that does not include yourself: a, {"HouseStark"=>"b"}', response.body)
    response = @browser.post('/games', { 'HouseStark' => 'a', 'HouseLannister' => 'z' }.to_json)
    assert_equal('No user with username: z', response.body)
    response = @browser.post('/games', { 'HouseStark' => 'a' }.to_json)
    assert_equal('A Game of Thrones (second edition) can only be played with 3-6 players, not 1', response.body)
    response = @browser.post('/games', { 'HouseStark' => 'a', 'HouseLannister' => 'b' }.to_json)
    assert_equal('A Game of Thrones (second edition) can only be played with 3-6 players, not 2', response.body)
  end

  def test_create_retrieve
    response = @browser.post('/games', { 'HouseStark' => 'a', 'HouseLannister' => 'b', 'HouseBaratheon' => 'c' }.to_json)
    game_id = JSON.parse(response.body)['game_id']
    response = @browser.get('/games/' + game_id.to_s)
    assert_equal(true, valid_json?(response.body), response.body)
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
    assert_equal(true, valid_json?(response.body))
    response = browser2.get('/games/' + a_game_id.to_s)
    assert_equal('b does not have access to ' + a_game_id.to_s, response.body)
    response = @browser.get('/games/' + b_game_id.to_s)
    assert_equal('a does not have access to ' + b_game_id.to_s, response.body)
    response = browser2.get('/games/' + b_game_id.to_s)
    assert_equal(true, valid_json?(response.body))
  end

  def test_game_information
    response = @browser.post('/games', { 'HouseStark' => 'a', 'HouseLannister' => 'b', 'HouseBaratheon' => 'c' }.to_json)
    game_id = JSON.parse(response.body)['game_id']
    response = @browser.get('/games/' + game_id.to_s)
    game = JSON.parse(response.body)
    game['houses'].each do |house|
      house['tokens'].each do |token|
        refute_operator(token.keys[0].constantize, :<, OrderToken)
      end
    end
    game['map'].each do |area, tokens|
      tokens.each do |token|
        refute_operator(token.keys[0].constantize, :<, OrderToken)
      end
    end
    refute_includes(game, 'wildling_deck')
    refute_includes(game, 'westers_deck_i')
    refute_includes(game, 'westers_deck_ii')
    refute_includes(game, 'westers_deck_iii')
  end

  def test_place_orders
    response = @browser.post('/games', { 'HouseStark' => 'a', 'HouseLannister' => 'b', 'HouseBaratheon' => 'c' }.to_json)
    game_id = JSON.parse(response.body)['game_id']
    response = @browser.post('/games/' + game_id.to_s + '/orders', { 'CastleBlack' => 'MarchOrder' }.to_json)
    assert_equal('Cannot place March Order (House Stark) because Castle Black (0) has no units', response.body)
    response = @browser.post('/games/' + game_id.to_s + '/orders', { 'Lannisport' => 'MarchOrder' }.to_json)
    assert_equal('Cannot place March Order (House Stark) because Lannisport (3) is controlled by House Lannister', response.body)
    response = @browser.post('/games/' + game_id.to_s + '/orders', { 'TheShiveringSea' => 'WeakMarchOrder', 'WhiteHarbor' => 'MarchOrder', 'Winterfell' => 'DefenseOrder' }.to_json)
    assert_equal(true, valid_json?(response.body), response.body)
  end
end
