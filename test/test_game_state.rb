class TestGameState < MiniTest::Test
  def test_initialize
    gs = GameState.create_new
    assert_equal(1, gs.round)
    assert_equal(:planning, gs.phase)
    assert_equal(:assign_orders, gs.step)
  end

  def test_next_step
    gs = GameState.create_new
    gs.next_step
    assert_equal(1, gs.round)
    assert_equal(:planning, gs.phase)
    assert_equal(:messenger_raven, gs.step)
    gs.next_step
    assert_equal(1, gs.round)
    assert_equal(:action, gs.phase)
    assert_equal(:resolve_raid_orders, gs.step)
    gs.next_step
    assert_equal(1, gs.round)
    assert_equal(:action, gs.phase)
    assert_equal(:resolve_march_orders, gs.step)
  end
end
