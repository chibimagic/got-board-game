class TestGamePlanningMessengerRaven < MiniTest::Test
  def setup
    @g = Game.create_new([HouseStark, HouseLannister, HouseBaratheon])
    @g.game_period = :messenger_raven
  end

  def test_reuse_token
    card = @g.look_at_wildling_deck
    assert_equal(:messenger_raven, @g.game_period)

    @g.map.area(Lannisport).receive_token!(MarchOrder.new(HouseLannister))
    e = assert_raises(RuntimeError) { @g.replace_order!(Lannisport, RaidOrder) }
    assert_equal('Messenger Raven token has already been used', e.message)
    e = assert_raises(RuntimeError) { @g.look_at_wildling_deck }
    assert_equal('Messenger Raven token has already been used', e.message)
    e = assert_raises(RuntimeError) { @g.skip_messenger_raven }
    assert_equal('Messenger Raven token has already been used', e.message)
  end

  def test_wildling_deck_top
    card = @g.look_at_wildling_deck
    @g.replace_wildling_card_top(card)
    assert_equal(:resolve_raid_orders, @g.game_period)
    e = assert_raises(RuntimeError) { @g.replace_wildling_card_bottom(card) }
    assert_match(/^Cannot replace card at bottom of wildling deck during .* Resolve Raid Orders step$/, e.message)
  end

  def test_wildling_deck_bottom
    card = @g.look_at_wildling_deck
    @g.replace_wildling_card_bottom(card)
    assert_equal(:resolve_raid_orders, @g.game_period)
    e = assert_raises(RuntimeError) { @g.replace_wildling_card_top(card) }
    assert_match(/^Cannot replace card at top of wildling deck during .* Resolve Raid Orders step$/, e.message)
  end

  def test_skip_messenger
    assert_equal(:messenger_raven, @g.game_period)
    @g.skip_messenger_raven
    assert_equal(:resolve_raid_orders, @g.game_period)
  end
end
