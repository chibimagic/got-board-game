class TestGameActionRaid < MiniTest::Test
  def raid_ready_game
    g = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    g.map = Map.create_new([])
    g.game_state.next_step
    g.game_state.next_step
    g
  end

  def test_raid_step
    g = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    g.map.area(CastleBlack).receive_token!(Footman.create_new(HouseLannister))
    g.map.area(CastleBlack).receive_token!(RaidOrder.new(HouseLannister))
    g.map.area(Winterfell).receive_token!(Footman.create_new(HouseStark))
    g.map.area(Winterfell).receive_token!(RaidOrder.new(HouseStark))
    g.game_state.next_step

    e = assert_raises(RuntimeError) { g.execute_raid_order!(CastleBlack, Winterfell) }
    assert_match(/^Cannot execute raid order during .*$/, e.message)

    g.game_state.next_step
    refute_raises { g.execute_raid_order!(CastleBlack, Winterfell) }

    g.game_state.next_step
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
      g = raid_ready_game
      g.map.area(datum[:from]).receive_token!(Footman.create_new(HouseStark))
      g.map.area(datum[:from]).receive_token!(RaidOrder.new(HouseStark))
      g.map.area(datum[:to]).receive_token!(Footman.create_new(HouseLannister))
      g.map.area(datum[:to]).receive_token!(SupportOrder.new(HouseLannister))
      if datum[:should_work]
        refute_raises(datum[:why]) { g.execute_raid_order!(datum[:from], datum[:to]) }
      else
        e = assert_raises(RuntimeError, datum[:why]) { g.execute_raid_order!(datum[:from], datum[:to]) }
        assert_equal('Cannot raid from ' + datum[:from].to_s + ' to unconnected ' + datum[:to].to_s, e.message)
      end
    end
  end

  def test_raid_invalid_area
    g = raid_ready_game
    e = assert_raises(RuntimeError) { g.execute_raid_order!(RaidOrder, nil) }
    assert_equal('Must execute raid order from area, not Raid Order', e.message)
    e = assert_raises(RuntimeError) { g.execute_raid_order!(CastleBlack, RaidOrder) }
    assert_equal('Must target area or nil with raid order, not Raid Order', e.message)
    e = assert_raises(RuntimeError) { g.execute_raid_order!(PortArea, nil) }
    assert_equal('Area is not a valid area', e.message)
  end

  def test_raid_ineligible
    g = raid_ready_game
    g.map.area(CastleBlack).receive_token!(Footman.create_new(HouseStark))
    g.map.area(Karhold).receive_token!(Footman.create_new(HouseLannister))
    g.map.area(Winterfell).receive_token!(Footman.create_new(HouseLannister))
    g.map.area(BayOfIce).receive_token!(Footman.create_new(HouseLannister))
    g.map.area(TheShiveringSea).receive_token!(Footman.create_new(HouseLannister))

    g.map.area(CastleBlack).receive_token!(RaidOrder.new(HouseStark))
    g.map.area(Karhold).receive_token!(DefenseOrder.new(HouseLannister))
    g.map.area(Winterfell).receive_token!(DefenseOrder.new(HouseLannister))
    g.map.area(BayOfIce).receive_token!(DefenseOrder.new(HouseLannister))
    g.map.area(TheShiveringSea).receive_token!(DefenseOrder.new(HouseLannister))

    g.execute_raid_order!(CastleBlack)

    assert_equal(false, g.map.area(CastleBlack).has_token?(OrderToken))

    assert_equal(true, g.map.area(Karhold).has_token?(Unit))
    assert_equal(true, g.map.area(Winterfell).has_token?(Unit))
    assert_equal(true, g.map.area(BayOfIce).has_token?(Unit))
    assert_equal(true, g.map.area(TheShiveringSea).has_token?(Unit))

    assert_equal(true, g.map.area(Karhold).has_token?(OrderToken))
    assert_equal(true, g.map.area(Winterfell).has_token?(OrderToken))
    assert_equal(true, g.map.area(BayOfIce).has_token?(OrderToken))
    assert_equal(true, g.map.area(TheShiveringSea).has_token?(OrderToken))
  end

  def test_raid_no_effect
    g = raid_ready_game
    g.map.area(CastleBlack).receive_token!(Footman.create_new(HouseLannister))
    g.map.area(Karhold).receive_token!(Footman.create_new(HouseStark))
    g.map.area(Winterfell).receive_token!(Footman.create_new(HouseStark))
    g.map.area(BayOfIce).receive_token!(Footman.create_new(HouseStark))
    g.map.area(TheShiveringSea).receive_token!(Footman.create_new(HouseStark))

    g.map.area(CastleBlack).receive_token!(RaidOrder.new(HouseLannister))
    g.map.area(Karhold).receive_token!(RaidOrder.new(HouseStark))
    g.map.area(Winterfell).receive_token!(RaidOrder.new(HouseStark))
    g.map.area(BayOfIce).receive_token!(RaidOrder.new(HouseStark))
    g.map.area(TheShiveringSea).receive_token!(RaidOrder.new(HouseStark))

    g.execute_raid_order!(CastleBlack)

    assert_equal(false, g.map.area(CastleBlack).has_token?(OrderToken))

    assert_equal(true, g.map.area(Karhold).has_token?(Unit))
    assert_equal(true, g.map.area(Winterfell).has_token?(Unit))
    assert_equal(true, g.map.area(BayOfIce).has_token?(Unit))
    assert_equal(true, g.map.area(TheShiveringSea).has_token?(Unit))

    assert_equal(true, g.map.area(Karhold).has_token?(OrderToken))
    assert_equal(true, g.map.area(Winterfell).has_token?(OrderToken))
    assert_equal(true, g.map.area(BayOfIce).has_token?(OrderToken))
    assert_equal(true, g.map.area(TheShiveringSea).has_token?(OrderToken))
  end

  def test_raid_own_order
    g = raid_ready_game
    g.map.area(CastleBlack).receive_token!(Footman.create_new(HouseStark))
    g.map.area(Winterfell).receive_token!(Footman.create_new(HouseStark))

    g.map.area(CastleBlack).receive_token!(RaidOrder.new(HouseStark))
    g.map.area(Winterfell).receive_token!(SpecialSupportOrder.new(HouseStark))

    e = assert_raises(RuntimeError) { g.execute_raid_order!(CastleBlack, Winterfell) }
    assert_equal('Cannot raid your own orders', e.message)

    assert_equal(true, g.map.area(CastleBlack).has_token?(Unit))
    assert_equal(true, g.map.area(Winterfell).has_token?(Unit))

    assert_equal(true, g.map.area(CastleBlack).has_token?(OrderToken))
    assert_equal(true, g.map.area(Winterfell).has_token?(OrderToken))
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
      g = raid_ready_game
      g.map.area(CastleBlack).receive_token!(Footman.create_new(HouseLannister))
      g.map.area(CastleBlack).receive_token!(RaidOrder.new(HouseLannister))
      g.map.area(Winterfell).receive_token!(Footman.create_new(HouseStark))
      g.map.area(Winterfell).receive_token!(datum[:raided_order].new(HouseStark))
      if datum[:should_work]
        refute_raises { g.execute_raid_order!(CastleBlack, Winterfell) }
      else
        e = assert_raises(RuntimeError) { g.execute_raid_order!(CastleBlack, Winterfell) }
        assert_equal('Cannot raid ' + datum[:raided_order].to_s + ' (House Stark)', e.message)
      end
    end
  end

  def test_raid_power_token
    g = raid_ready_game
    raiding_player_initial_power_token_count = g.house(HouseLannister).count_tokens(PowerToken)
    raided_player_initial_power_token_count = g.house(HouseStark).count_tokens(PowerToken)

    g.map.area(CastleBlack).receive_token!(Footman.create_new(HouseLannister))
    g.map.area(CastleBlack).receive_token!(RaidOrder.new(HouseLannister))
    g.map.area(Winterfell).receive_token!(Footman.create_new(HouseStark))
    g.map.area(Winterfell).receive_token!(ConsolidatePowerOrder.new(HouseStark))

    g.execute_raid_order!(CastleBlack, Winterfell)

    raiding_player_final_power_token_count = g.house(HouseLannister).count_tokens(PowerToken)
    raided_player_final_power_token_count = g.house(HouseStark).count_tokens(PowerToken)

    assert_equal(raiding_player_initial_power_token_count + 1, raiding_player_final_power_token_count)
    assert_equal(raided_player_initial_power_token_count - 1, raided_player_final_power_token_count)
  end
end
