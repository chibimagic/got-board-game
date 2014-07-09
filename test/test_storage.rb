class TestStorage < MiniTest::Test
  def test_storage
    original_game = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    game_id = Storage.save_game(nil, original_game)
    restored_game = Storage.get_game(game_id)
    assert_equal(original_game, restored_game)
  end
end
