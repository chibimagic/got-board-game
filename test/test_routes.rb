class TestRoutes < MiniTest::Test
  def get(relative_url)
    @browser.get(relative_url).body
  end

  def post(relative_url, body)
    @browser.post(relative_url, body.to_json).body
  end

  def setup
    @browser = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
    usernames = ['a', 'b', 'c', 'd', 'e', 'f']
    usernames.each do |username|
      post('/users', { 'username' => username, 'password' => 'password', 'player_name' => username })
    end
    post('/session', { 'username' => usernames[0], 'password' => 'password' })
  end

  def test_create_user_invalid
    response = post('/users', '')
    assert_equal('JSON input expected', response)
    response = post('/users', { 'username' => 'username' })
    assert_equal('Format: {"username":"jdoe","password":"password","player_name":"John"}', response)
    response = post('/users', { 'password' => 'password' })
    assert_equal('Format: {"username":"jdoe","password":"password","player_name":"John"}', response)
    response = post('/users', { 'player_name' => 'player name' })
    assert_equal('Format: {"username":"jdoe","password":"password","player_name":"John"}', response)
  end

  def test_create_game_invalid
    response = post('/games', '')
    assert_equal('JSON input expected', response)
    response = post('/games', {})
    assert_equal('Cannot create a game that does not include yourself: a, {}', response)
    response = post('/games', { 'HouseStark' => 'a' })
    assert_equal('A Game of Thrones (second edition) can only be played with 3-6 players, not 1', response)
    response = post('/games', { 'HouseStark' => 'a', 'HouseLannister' => 'b' })
    assert_equal('A Game of Thrones (second edition) can only be played with 3-6 players, not 2', response)
  end

  def test_create_retrieve
    response = post('/games', { 'HouseStark' => 'a', 'HouseLannister' => 'b', 'HouseBaratheon' => 'c' })
    game_id = JSON.parse(response)['game_id']
    response = get('/games/' + game_id.to_s)
    assert_kind_of(String, response)
  end
end
