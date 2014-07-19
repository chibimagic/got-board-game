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

  def test_create_game_invalid
    response = @browser.post('/games', '')
    assert_equal('JSON input expected', response.body)
    response = @browser.post('/games', {}.to_json)
    assert_equal('Cannot create a game that does not include yourself: a, {}', response.body)
    response = @browser.post('/games', { 'HouseStark' => 'b' }.to_json)
    assert_equal('Cannot create a game that does not include yourself: a, {"HouseStark"=>"b"}', response.body)
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
end
