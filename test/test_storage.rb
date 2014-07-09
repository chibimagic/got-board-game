class TestStorage < MiniTest::Test
  def test_storage
    original_game = Game.new_game([HouseStark.new, HouseLannister.new, HouseBaratheon.new])
    game_id = Storage.save_game(nil, original_game)
    restored_game = Storage.get_game(game_id)
    assert_equal(original_game, restored_game)
  end
end
