class TestGamePlanningMessengerRaven < MiniTest::Test
  def setup
    @g = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    @g.place_order(HouseStark, TheShiveringSea, WeakMarchOrder)
    @g.place_order(HouseStark, WhiteHarbor, MarchOrder)
    @g.place_order(HouseStark, Winterfell, DefenseOrder)
    @g.place_order(HouseLannister, TheGoldenSound, WeakMarchOrder)
    @g.place_order(HouseLannister, Lannisport, MarchOrder)
    @g.place_order(HouseLannister, StoneySept, DefenseOrder)
    @g.place_order(HouseBaratheon, ShipbreakerBay, WeakMarchOrder)
    @g.place_order(HouseBaratheon, Dragonstone, MarchOrder)
    @g.place_order(HouseBaratheon, Kingswood, DefenseOrder)
  end

  def test_reuse_token
    card = @g.look_at_wildling_deck
    assert_equal(:messenger_raven, @g.game_state.game_period)

    e = assert_raises(RuntimeError) { @g.replace_order(Lannisport, RaidOrder) }
    assert_equal('Messenger Raven token has already been used', e.message)
    e = assert_raises(RuntimeError) { @g.look_at_wildling_deck }
    assert_equal('Messenger Raven token has already been used', e.message)
    e = assert_raises(RuntimeError) { @g.skip_messenger_raven }
    assert_equal('Messenger Raven token has already been used', e.message)
  end

  def test_wildling_deck_top
    card = @g.look_at_wildling_deck
    @g.replace_wildling_card_top(card)
    assert_equal(:resolve_raid_orders, @g.game_state.game_period)
    e = assert_raises(RuntimeError) { @g.replace_wildling_card_bottom(card) }
    assert_match(/^Cannot replace card at bottom of wildling deck during .* Resolve Raid Orders step$/, e.message)
  end

  def test_wildling_deck_bottom
    card = @g.look_at_wildling_deck
    @g.replace_wildling_card_bottom(card)
    assert_equal(:resolve_raid_orders, @g.game_state.game_period)
    e = assert_raises(RuntimeError) { @g.replace_wildling_card_top(card) }
    assert_match(/^Cannot replace card at top of wildling deck during .* Resolve Raid Orders step$/, e.message)
  end

  def test_skip_messenger
    assert_equal(:messenger_raven, @g.game_state.game_period)
    @g.skip_messenger_raven
    assert_equal(:resolve_raid_orders, @g.game_state.game_period)
  end
end
