class GameActionRaidTest < MiniTest::Test
  def empty_map_game
    g = Game.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g.map = Map.create_new([])
    g
  end

  def test_raid_step
    g = Game.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g.map.area(CastleBlack).receive!(Footman.create_new(HouseLannister))
    g.map.area(CastleBlack).receive!(RaidOrder.new(HouseLannister))
    g.map.area(Winterfell).receive!(Footman.create_new(HouseStark))
    g.map.area(Winterfell).receive!(RaidOrder.new(HouseStark))

    e = assert_raises(RuntimeError) { g.execute_raid_order!(CastleBlack, Winterfell) }
    assert_match(/^Cannot execute raid order during .*$/, e.message)

    g.change_game_period(:resolve_raid_orders)
    refute_raises { g.execute_raid_order!(CastleBlack, Winterfell) }

    e = assert_raises(RuntimeError) { g.execute_raid_order!(CastleBlack, Winterfell) }
    assert_match(/^Cannot execute raid order during .*$/, e.message)
  end

  def test_raid_adjacent_area
    data = [
      # Land to land
      { :from => CastleBlack, :to => Karhold, :should_work => true, :why => 'Adjacent land areas should be able to raid each other' },
      { :from => Karhold, :to => CastleBlack, :should_work => true, :why => 'Adjacent land areas should be able to raid each other regardless of order' },
      { :from => CastleBlack, :to => TheReach, :should_work => false, :why => 'Non-adjacent land areas should not be able to raid each other' },
      { :from => TheReach, :to => CastleBlack, :should_work => false, :why => 'Non-adjacent land areas should not be able to raid each other regardless of order' },
      # Sea to sea
      { :from => TheShiveringSea, :to => TheNarrowSea, :should_work => true, :why => 'Adjacent sea areas should be able to raid each other' },
      { :from => TheNarrowSea, :to => TheShiveringSea, :should_work => true, :why => 'Adjacent sea areas should be able to raid each other regardless of order' },
      { :from => TheShiveringSea, :to => WestSummerSea, :should_work => false, :why => 'Non-adjacent sea areas should not be able to raid each other' },
      { :from => WestSummerSea, :to => TheShiveringSea, :should_work => false, :why => 'Non-adjacent sea areas should not be able to raid each other regardless of order' },
      # Raid from port
      { :from => WhiteHarborPortToTheNarrowSea, :to => TheNarrowSea, :should_work => true, :why => 'Ports can raid the adjacent sea area' },
      { :from => WhiteHarborPortToTheNarrowSea, :to => WhiteHarbor, :should_work => false, :why => 'Ports cannot raid the adjacent land area' },
      { :from => WhiteHarborPortToTheNarrowSea, :to => WestSummerSea, :should_work => false, :why => 'Ports cannot raid non-adjacent sea areas' },
      { :from => WhiteHarborPortToTheNarrowSea, :to => TheReach, :should_work => false, :why => 'Ports cannot raid non-adjacent land areas' },
      # Raid on port
      { :from => TheNarrowSea, :to => WhiteHarborPortToTheNarrowSea, :should_work => true, :why => 'The adjacent sea area can raid a port' },
      { :from => WhiteHarbor, :to => WhiteHarborPortToTheNarrowSea, :should_work => false, :why => 'The adjacent land area cannot raid a port' },
      { :from => WestSummerSea, :to => WhiteHarborPortToTheNarrowSea, :should_work => false, :why => 'Non-adjacent sea areas cannot raid a port' },
      { :from => TheReach, :to => WhiteHarborPortToTheNarrowSea, :should_work => false, :why => 'Non-adjacent land areas cannot raid a port' },
    ]
    data.each do |datum|
      g = empty_map_game
      token_class = datum[:from] < LandArea ? Footman : Ship
      g.map.area(datum[:from]).receive!(token_class.create_new(HouseStark))
      g.map.area(datum[:from]).receive!(RaidOrder.new(HouseStark))
      token_class = datum[:to] < LandArea ? Footman : Ship
      g.map.area(datum[:to]).receive!(token_class.create_new(HouseLannister))
      g.map.area(datum[:to]).receive!(SupportOrder.new(HouseLannister))
      g.change_game_period(:resolve_raid_orders)
      if datum[:should_work]
        refute_raises(datum[:why]) { g.execute_raid_order!(datum[:from], datum[:to]) }
      else
        e = assert_raises(RuntimeError, datum[:why]) { g.execute_raid_order!(datum[:from], datum[:to]) }
        assert_equal('Cannot raid from ' + datum[:from].to_s + ' to unconnected ' + datum[:to].to_s, e.message)
      end
    end
  end

  def test_raid_invalid_area
    g = empty_map_game
    g.map.area(CastleBlack).receive!(Footman.create_new(HouseStark))
    g.map.area(CastleBlack).receive!(RaidOrder.new(HouseStark))
    g.change_game_period(:resolve_raid_orders)

    e = assert_raises(RuntimeError) { g.execute_raid_order!(RaidOrder, nil) }
    assert_equal('Must execute raid order from area, not Raid Order', e.message)
    e = assert_raises(RuntimeError) { g.execute_raid_order!(CastleBlack, RaidOrder) }
    assert_equal('Must target area or nil with raid order, not Raid Order', e.message)
    e = assert_raises(RuntimeError) { g.execute_raid_order!(PortArea, nil) }
    assert_equal('Invalid area Area', e.message)
  end

  def test_raid_ineligible
    g = empty_map_game
    g.map.area(CastleBlack).receive!(Footman.create_new(HouseStark))
    g.map.area(Karhold).receive!(Footman.create_new(HouseLannister))
    g.map.area(Winterfell).receive!(Footman.create_new(HouseLannister))
    g.map.area(BayOfIce).receive!(Ship.create_new(HouseLannister))
    g.map.area(TheShiveringSea).receive!(Ship.create_new(HouseLannister))

    g.map.area(CastleBlack).receive!(RaidOrder.new(HouseStark))
    g.map.area(Karhold).receive!(ConsolidatePowerOrder.new(HouseLannister))
    g.map.area(Winterfell).receive!(ConsolidatePowerOrder.new(HouseLannister))
    g.map.area(BayOfIce).receive!(ConsolidatePowerOrder.new(HouseLannister))
    g.map.area(TheShiveringSea).receive!(ConsolidatePowerOrder.new(HouseLannister))

    g.change_game_period(:resolve_raid_orders)
    g.execute_raid_order!(CastleBlack)

    assert_equal(false, g.map.area(CastleBlack).has?(OrderToken))

    assert_equal(true, g.map.area(Karhold).has?(Unit))
    assert_equal(true, g.map.area(Winterfell).has?(Unit))
    assert_equal(true, g.map.area(BayOfIce).has?(Unit))
    assert_equal(true, g.map.area(TheShiveringSea).has?(Unit))

    assert_equal(true, g.map.area(Karhold).has?(OrderToken))
    assert_equal(true, g.map.area(Winterfell).has?(OrderToken))
    assert_equal(true, g.map.area(BayOfIce).has?(OrderToken))
    assert_equal(true, g.map.area(TheShiveringSea).has?(OrderToken))
  end

  def test_raid_no_effect
    g = empty_map_game
    g.map.area(CastleBlack).receive!(Footman.create_new(HouseLannister))
    g.map.area(Karhold).receive!(Footman.create_new(HouseStark))
    g.map.area(Winterfell).receive!(Footman.create_new(HouseStark))
    g.map.area(BayOfIce).receive!(Ship.create_new(HouseStark))
    g.map.area(TheShiveringSea).receive!(Ship.create_new(HouseStark))

    g.map.area(CastleBlack).receive!(RaidOrder.new(HouseLannister))
    g.map.area(Karhold).receive!(RaidOrder.new(HouseStark))
    g.map.area(Winterfell).receive!(RaidOrder.new(HouseStark))
    g.map.area(BayOfIce).receive!(RaidOrder.new(HouseStark))
    g.map.area(TheShiveringSea).receive!(RaidOrder.new(HouseStark))

    g.change_game_period(:resolve_raid_orders)
    g.execute_raid_order!(CastleBlack)

    assert_equal(false, g.map.area(CastleBlack).has?(OrderToken))

    assert_equal(true, g.map.area(Karhold).has?(Unit))
    assert_equal(true, g.map.area(Winterfell).has?(Unit))
    assert_equal(true, g.map.area(BayOfIce).has?(Unit))
    assert_equal(true, g.map.area(TheShiveringSea).has?(Unit))

    assert_equal(true, g.map.area(Karhold).has?(OrderToken))
    assert_equal(true, g.map.area(Winterfell).has?(OrderToken))
    assert_equal(true, g.map.area(BayOfIce).has?(OrderToken))
    assert_equal(true, g.map.area(TheShiveringSea).has?(OrderToken))
  end

  def test_raid_own_order
    g = empty_map_game
    g.map.area(CastleBlack).receive!(Footman.create_new(HouseStark))
    g.map.area(Winterfell).receive!(Footman.create_new(HouseStark))

    g.map.area(CastleBlack).receive!(RaidOrder.new(HouseStark))
    g.map.area(Winterfell).receive!(SpecialSupportOrder.new(HouseStark))

    g.change_game_period(:resolve_raid_orders)
    e = assert_raises(RuntimeError) { g.execute_raid_order!(CastleBlack, Winterfell) }
    assert_equal('Cannot raid your own orders', e.message)

    assert_equal(true, g.map.area(CastleBlack).has?(Unit))
    assert_equal(true, g.map.area(Winterfell).has?(Unit))

    assert_equal(true, g.map.area(CastleBlack).has?(OrderToken))
    assert_equal(true, g.map.area(Winterfell).has?(OrderToken))
  end

  def test_raid_raidable_orders
    data = [
      { :raided_order => WeakMarchOrder, :should_work => false },
      { :raided_order => MarchOrder, :should_work => false },
      { :raided_order => SpecialMarchOrder, :should_work => false },
      { :raided_order => DefenseOrder, :should_work => false },
      { :raided_order => SpecialDefenseOrder, :should_work => false },
      { :raided_order => SupportOrder, :should_work => true },
      { :raided_order => SpecialSupportOrder, :should_work => true },
      { :raided_order => RaidOrder, :should_work => true },
      { :raided_order => SpecialRaidOrder, :should_work => true },
      { :raided_order => ConsolidatePowerOrder, :should_work => true },
      { :raided_order => SpecialConsolidatePowerOrder, :should_work => true },
    ]
    data.each do |datum|
      g = empty_map_game
      g.map.area(CastleBlack).receive!(Footman.create_new(HouseLannister))
      g.map.area(CastleBlack).receive!(RaidOrder.new(HouseLannister))
      g.map.area(Winterfell).receive!(Footman.create_new(HouseStark))
      g.map.area(Winterfell).receive!(datum[:raided_order].new(HouseStark))
      g.change_game_period(:resolve_raid_orders)
      if datum[:should_work]
        refute_raises { g.execute_raid_order!(CastleBlack, Winterfell) }
      else
        e = assert_raises(RuntimeError) { g.execute_raid_order!(CastleBlack, Winterfell) }
        assert_equal('Cannot raid ' + datum[:raided_order].to_s + ' (House Stark)', e.message)
      end
    end
  end

  def test_raid_special
    g = empty_map_game
    g.map.area(CastleBlack).receive!(Footman.create_new(HouseLannister))
    g.map.area(CastleBlack).receive!(SpecialRaidOrder.new(HouseLannister))
    g.map.area(Winterfell).receive!(Footman.create_new(HouseStark))
    g.map.area(Winterfell).receive!(DefenseOrder.new(HouseStark))

    g.change_game_period(:resolve_raid_orders)
    refute_raises { g.execute_raid_order!(CastleBlack, Winterfell) }
  end

  def test_raid_power_token
    g = empty_map_game
    raiding_player_initial_power_token_count = g.house(HouseLannister).count(PowerToken)
    raided_player_initial_power_token_count = g.house(HouseStark).count(PowerToken)

    g.map.area(CastleBlack).receive!(Footman.create_new(HouseLannister))
    g.map.area(CastleBlack).receive!(RaidOrder.new(HouseLannister))
    g.map.area(Winterfell).receive!(Footman.create_new(HouseStark))
    g.map.area(Winterfell).receive!(ConsolidatePowerOrder.new(HouseStark))

    g.change_game_period(:resolve_raid_orders)
    g.execute_raid_order!(CastleBlack, Winterfell)

    raiding_player_final_power_token_count = g.house(HouseLannister).count(PowerToken)
    raided_player_final_power_token_count = g.house(HouseStark).count(PowerToken)

    assert_equal(raiding_player_initial_power_token_count + 1, raiding_player_final_power_token_count)
    assert_equal(raided_player_initial_power_token_count - 1, raided_player_final_power_token_count)
  end
end
