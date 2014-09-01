class GamePlanningAssignTest < MiniTest::Test
  def setup
    @g = Game.create_new([HouseStark, HouseLannister, HouseBaratheon])
  end

  def test_special_orders
    assert_equal(1, @g.kings_court_track.special_orders_allowed(HouseBaratheon))
    refute_raises { @g.place_order!(HouseBaratheon, ShipbreakerBay, MarchOrder) }
    refute_raises { @g.place_order!(HouseBaratheon, Dragonstone, SpecialDefenseOrder) }
    e = assert_raises(RuntimeError) { @g.place_order!(HouseBaratheon, Dragonstone, SpecialMarchOrder) }
    assert_equal('House Baratheon can only place 1 special order', e.message)
  end

  def test_next_step
    assert_equal(:assign_orders, @g.game_period)
    @g.place_order!(HouseStark, TheShiveringSea, WeakMarchOrder)
    @g.place_order!(HouseStark, WhiteHarbor, MarchOrder)
    @g.place_order!(HouseStark, Winterfell, DefenseOrder)
    @g.place_order!(HouseLannister, TheGoldenSound, WeakMarchOrder)
    @g.place_order!(HouseLannister, Lannisport, MarchOrder)
    @g.place_order!(HouseLannister, StoneySept, DefenseOrder)
    @g.place_order!(HouseBaratheon, ShipbreakerBay, WeakMarchOrder)
    @g.place_order!(HouseBaratheon, Dragonstone, MarchOrder)
    @g.place_order!(HouseBaratheon, Kingswood, DefenseOrder)
    assert_equal(:messenger_raven, @g.game_period)
    e = assert_raises(RuntimeError) { @g.place_order!(HouseStark, TheShiveringSea, SpecialMarchOrder) }
    assert_equal('Cannot place order during Planning phase, Messenger Raven step', e.message)
  end

  def test_replace_order!
    e = assert_raises(RuntimeError) { @g.replace_order!(CastleBlack, WeakMarchOrder) }
    assert_equal('Cannot replace order during Planning phase, Assign Orders step', e.message)

    @g.place_order!(HouseStark, TheShiveringSea, WeakMarchOrder)
    @g.place_order!(HouseStark, WhiteHarbor, MarchOrder)
    @g.place_order!(HouseStark, Winterfell, DefenseOrder)
    @g.place_order!(HouseLannister, TheGoldenSound, WeakMarchOrder)
    @g.place_order!(HouseLannister, Lannisport, MarchOrder)
    @g.place_order!(HouseLannister, StoneySept, DefenseOrder)
    @g.place_order!(HouseBaratheon, ShipbreakerBay, WeakMarchOrder)
    @g.place_order!(HouseBaratheon, Dragonstone, MarchOrder)
    @g.place_order!(HouseBaratheon, Kingswood, DefenseOrder)

    e = assert_raises(RuntimeError) { @g.replace_order!(CastleBlack, WeakMarchOrder) }
    assert_equal('Castle Black (0) has no items matching Order Token', e.message)
    e = assert_raises(RuntimeError) { @g.replace_order!(Winterfell, WeakMarchOrder) }
    assert_equal('Only the holder of the Messenger Raven token may replace an order', e.message)
    e = assert_raises(RuntimeError) { @g.replace_order!(Lannisport, WeakMarchOrder) }
    assert_equal('House Lannister has no items matching March Order', e.message)

    refute_raises { @g.replace_order!(Lannisport, RaidOrder) }

    e = assert_raises(RuntimeError) { @g.replace_order!(Lannisport, RaidOrder) }
    assert_match(/^Cannot replace order during .* Resolve Raid Orders step$/, e.message)
  end
end