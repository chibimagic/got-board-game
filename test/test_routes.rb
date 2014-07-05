class TestRoutes < MiniTest::Test
  def test_create_game
    response = RestClient.post('http://0.0.0.0:4567/games', {}.to_json)
    assert_equal('A Game of Thrones (second edition) can only be played with 3-6 players, not 0', response)
    response = RestClient.post('http://0.0.0.0:4567/games', { 'Stark' => 'a' }.to_json)
    assert_equal('A Game of Thrones (second edition) can only be played with 3-6 players, not 1', response)
    response = RestClient.post('http://0.0.0.0:4567/games', { 'Stark' => 'a', 'Lannister' => 'b' }.to_json)
    assert_equal('A Game of Thrones (second edition) can only be played with 3-6 players, not 2', response)
  end
end
