class TestRoutes < MiniTest::Test
  def get(relative_url)
    RestClient.get('http://0.0.0.0:4567' + relative_url)
  end

  def post(relative_url, body)
    RestClient.post('http://0.0.0.0:4567' + relative_url, body.to_json)
  end

  def setup
    usernames = ['a', 'b', 'c', 'd', 'e', 'f']
    usernames.each do |username|
      post('/users', { 'username' => username, 'password' => 'password', 'player_name' => username })
    end
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
    assert_equal('A Game of Thrones (second edition) can only be played with 3-6 players, not 0', response)
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
