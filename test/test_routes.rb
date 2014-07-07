class TestRoutes < MiniTest::Test
  def test_create_game
    response = RestClient.post('http://0.0.0.0:4567/games', '')
    assert_equal('JSON input expected', response)
    response = RestClient.post('http://0.0.0.0:4567/games', {}.to_json)
    assert_equal('A Game of Thrones (second edition) can only be played with 3-6 players, not 0', response)
    response = RestClient.post('http://0.0.0.0:4567/games', { 'Stark' => 'a' }.to_json)
    assert_equal('A Game of Thrones (second edition) can only be played with 3-6 players, not 1', response)
    response = RestClient.post('http://0.0.0.0:4567/games', { 'Stark' => 'a', 'Lannister' => 'b' }.to_json)
    assert_equal('A Game of Thrones (second edition) can only be played with 3-6 players, not 2', response)
  end

  def test_create_retrieve
    response = RestClient.post('http://0.0.0.0:4567/games', { 'Stark' => 'a', 'Lannister' => 'b', 'Baratheon' => 'c' }.to_json)
    game_id = JSON.parse(response)['game_id']
    response = RestClient.get('http://0.0.0.0:4567/games/' + game_id.to_s)
    assert_kind_of(String, response)
  end
end
