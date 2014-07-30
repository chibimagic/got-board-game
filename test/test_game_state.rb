class TestGameState < MiniTest::Test
  def test_initialize
    gs = GameState.create_new
    assert_equal(1, gs.round)
    assert_equal(:assign_orders, gs.game_period)
    assert_equal('Planning', gs.phase)
    assert_equal('Assign Orders', gs.step)
  end

  def test_next_step
    gs = GameState.create_new
    gs.next_step
    assert_equal(1, gs.round)
    assert_equal(:messenger_raven, gs.game_period)
    assert_equal('Planning', gs.phase)
    assert_equal('Messenger Raven', gs.step)
    gs.next_step
    assert_equal(1, gs.round)
    assert_equal(:resolve_raid_orders, gs.game_period)
    assert_equal('Action', gs.phase)
    assert_equal('Resolve Raid Orders', gs.step)
    gs.next_step
    assert_equal(1, gs.round)
    assert_equal(:resolve_march_orders, gs.game_period)
    assert_equal('Action', gs.phase)
    assert_equal('Resolve March Orders', gs.step)
  end
end
