class TestGamePlanningMessengerRaven < MiniTest::Test
  def setup
    @g = Game.create_new([HouseStark, HouseLannister, HouseBaratheon])
    @g.change_game_period(:messenger_raven)
  end

  def test_reuse_token
    card = @g.look_at_wildling_deck
    assert_equal(:messenger_raven, @g.game_period)

    @g.map.area(Lannisport).receive!(MarchOrder.new(HouseLannister))
    e = assert_raises(RuntimeError) { @g.replace_order!(Lannisport, RaidOrder) }
    assert_equal('Messenger Raven token has already been used', e.message)
    e = assert_raises(RuntimeError) { @g.look_at_wildling_deck }
    assert_equal('Messenger Raven token has already been used', e.message)
    e = assert_raises(RuntimeError) { @g.skip_messenger_raven }
    assert_equal('Messenger Raven token has already been used', e.message)
  end

  def test_wildling_deck_top
    @g.look_at_wildling_deck
    @g.replace_wildling_card_top
    refute_equal(:messenger_raven, @g.game_period)
    e = assert_raises(RuntimeError) { @g.replace_wildling_card_bottom }
    assert_match(/^Cannot replace card at bottom of wildling deck during /, e.message)
  end

  def test_wildling_deck_bottom
    @g.look_at_wildling_deck
    @g.replace_wildling_card_bottom
    refute_equal(:messenger_raven, @g.game_period)
    e = assert_raises(RuntimeError) { @g.replace_wildling_card_top }
    assert_match(/^Cannot replace card at top of wildling deck during /, e.message)
  end

  def test_skip_messenger
    assert_equal(:messenger_raven, @g.game_period)
    @g.skip_messenger_raven
    refute_equal(:messenger_raven, @g.game_period)
  end
end
