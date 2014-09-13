class GameControllerTest < MiniTest::Test
  def test_game_info
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    game = g.game_info
    game[:houses].each do |house, house_info|
      house_info[:tokens].each do |token|
        refute_operator(token.keys[0].constantize, :<, OrderToken)
      end
    end
    game[:map][:areas].each do |area, tokens|
      tokens.each do |token|
        refute_operator(token.keys[0].constantize, :<, OrderToken)
      end
    end
    refute_includes(game, :wildling_deck)
    refute_includes(game, :westers_deck_i)
    refute_includes(game, :westers_deck_ii)
    refute_includes(game, :westers_deck_iii)
  end

  def test_bid_multiple
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g.bid!(HouseStark, 1)
    e = assert_raises(RuntimeError) { g.bid!(HouseStark, 1) }
    assert_equal('House Stark has already bid 1', e.message)
  end

  def test_bid_more
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    e = assert_raises(RuntimeError) { g.bid!(HouseStark, 10) }
    assert_equal('Cannot bid 10 when House Stark only has 5', e.message)
  end

  def test_place_orders_special
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    assert_equal(1, g.kings_court_track.special_orders_allowed(HouseBaratheon))
    refute_raises { g.place_order!(HouseBaratheon, ShipbreakerBay, MarchOrder) }
    refute_raises { g.place_order!(HouseBaratheon, Dragonstone, SpecialDefenseOrder) }
    e = assert_raises(RuntimeError) { g.place_order!(HouseBaratheon, Dragonstone, SpecialMarchOrder) }
    assert_equal('House Baratheon can only place 1 special order', e.message)
  end

  def test_messenger_reuse_token
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g.change_game_period(:messenger_raven)
    card = g.look_at_wildling_deck
    assert_equal(:messenger_raven, g.game_period)

    g.map.area(Lannisport).receive!(MarchOrder.new(HouseLannister))
    e = assert_raises(RuntimeError) { g.replace_order!(Lannisport, RaidOrder) }
    assert_equal('Messenger Raven token has already been used', e.message)
    e = assert_raises(RuntimeError) { g.look_at_wildling_deck }
    assert_equal('Messenger Raven token has already been used', e.message)
    e = assert_raises(RuntimeError) { g.skip_messenger_raven }
    assert_equal('Messenger Raven token has already been used', e.message)
  end

  def test_messenger_wildling_deck_top
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g.change_game_period(:messenger_raven)
    g.look_at_wildling_deck
    g.replace_wildling_card_top
    refute_equal(:messenger_raven, g.game_period)
    e = assert_raises(RuntimeError) { g.replace_wildling_card_bottom }
    assert_match(/^Cannot replace card at bottom of wildling deck during /, e.message)
  end

  def test_messenger_wildling_deck_bottom
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g.change_game_period(:messenger_raven)
    g.look_at_wildling_deck
    g.replace_wildling_card_bottom
    refute_equal(:messenger_raven, g.game_period)
    e = assert_raises(RuntimeError) { g.replace_wildling_card_top }
    assert_match(/^Cannot replace card at top of wildling deck during /, e.message)
  end

  def test_messenger_skip
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g.change_game_period(:messenger_raven)
    assert_equal(:messenger_raven, g.game_period)
    g.skip_messenger_raven
    refute_equal(:messenger_raven, g.game_period)
  end

  def test_replace_order
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    e = assert_raises(RuntimeError) { g.replace_order!(CastleBlack, WeakMarchOrder) }
    assert_equal('Cannot replace order during Planning phase, Assign Orders step', e.message)

    g.place_order!(HouseStark, TheShiveringSea, WeakMarchOrder)
    g.place_order!(HouseStark, WhiteHarbor, MarchOrder)
    g.place_order!(HouseStark, Winterfell, DefenseOrder)
    g.place_order!(HouseLannister, TheGoldenSound, WeakMarchOrder)
    g.place_order!(HouseLannister, Lannisport, MarchOrder)
    g.place_order!(HouseLannister, StoneySept, DefenseOrder)
    g.place_order!(HouseBaratheon, ShipbreakerBay, WeakMarchOrder)
    g.place_order!(HouseBaratheon, Dragonstone, MarchOrder)
    g.place_order!(HouseBaratheon, Kingswood, DefenseOrder)

    e = assert_raises(RuntimeError) { g.replace_order!(CastleBlack, WeakMarchOrder) }
    assert_equal('Castle Black (0) has no items matching Order Token', e.message)
    e = assert_raises(RuntimeError) { g.replace_order!(Winterfell, WeakMarchOrder) }
    assert_equal('Only the holder of the Messenger Raven token may replace an order', e.message)
    e = assert_raises(RuntimeError) { g.replace_order!(Lannisport, WeakMarchOrder) }
    assert_equal('House Lannister has no items matching March Order', e.message)

    refute_raises { g.replace_order!(Lannisport, RaidOrder) }

    e = assert_raises(RuntimeError) { g.replace_order!(Lannisport, RaidOrder) }
    assert_match(/^Cannot replace order during .* Resolve Raid Orders step$/, e.message)
  end

  def test_raid_step
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
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
      g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
      g.map = Map.create_new([])
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
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g.map = Map.create_new([])
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
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g.map = Map.create_new([])
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
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g.map = Map.create_new([])
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
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g.map = Map.create_new([])
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
      g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
      g.map = Map.create_new([])
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
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g.map = Map.create_new([])
    g.map.area(CastleBlack).receive!(Footman.create_new(HouseLannister))
    g.map.area(CastleBlack).receive!(SpecialRaidOrder.new(HouseLannister))
    g.map.area(Winterfell).receive!(Footman.create_new(HouseStark))
    g.map.area(Winterfell).receive!(DefenseOrder.new(HouseStark))

    g.change_game_period(:resolve_raid_orders)
    refute_raises { g.execute_raid_order!(CastleBlack, Winterfell) }
  end

  def test_raid_power_token
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g.map = Map.create_new([])
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

  def test_march_all_units
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g.map = Map.create_new([])
    g.map.area(Winterfell).receive!(Footman.create_new(HouseStark))
    g.map.area(Winterfell).receive!(Footman.create_new(HouseStark))
    g.map.area(Winterfell).receive!(MarchOrder.new(HouseStark))
    g.change_game_period(:resolve_march_orders)
    e = assert_raises(RuntimeError) { g.execute_march_order!(Winterfell, { Winterfell => [Footman] }, nil) }
    assert_equal('Marched units [Footman] must match existing units in Winterfell [Footman, Footman]', e.message)
  end

  def test_march_port_combat
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g.map = Map.create_new([])
    g.map.area(BayOfIce).receive!(Ship.create_new(HouseStark))
    g.map.area(WinterfellPortToBayOfIce).receive!(Ship.create_new(HouseLannister))
    g.map.area(BayOfIce).receive!(MarchOrder.new(HouseStark))
    g.change_game_period(:resolve_march_orders)
    e = assert_raises(RuntimeError) { g.execute_march_order!(BayOfIce, { WinterfellPortToBayOfIce => [Ship] }, nil) }
    assert_equal('Cannot initiate combat in port area Winterfell Port (Bay of Ice)', e.message)
  end

  def test_march_adjacent_areas
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g.map = Map.create_new([])
    g.map.area(Winterfell).receive!(Footman.create_new(HouseStark))
    g.map.area(Winterfell).receive!(MarchOrder.new(HouseStark))
    g.change_game_period(:resolve_march_orders)
    e = assert_raises(RuntimeError) { g.execute_march_order!(Winterfell, { Sunspear => [Footman] }, nil) }
    assert_equal('Cannot march from Winterfell to unconnected Sunspear', e.message)
  end

  def test_march_multiple_combat
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g.map = Map.create_new([])
    g.map.area(CastleBlack).receive!(Footman.create_new(HouseLannister))
    g.map.area(Karhold).receive!(Footman.create_new(HouseLannister))
    g.map.area(Winterfell).receive!(Footman.create_new(HouseStark))
    g.map.area(Winterfell).receive!(Footman.create_new(HouseStark))
    g.map.area(Winterfell).receive!(Footman.create_new(HouseStark))
    g.map.area(Winterfell).receive!(MarchOrder.new(HouseStark))
    g.change_game_period(:resolve_march_orders)
    e = assert_raises(RuntimeError) { g.execute_march_order!(Winterfell, { CastleBlack => [Footman], Karhold => [Footman], Winterfell => [Footman] }, nil) }
    assert_equal('Cannot march into more than one area containing units of another House: [CastleBlack, Karhold]', e.message)
  end

  def test_march_establish_control
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g.map = Map.create_new([])
    g.map.set_level(HouseStark, 1)
    g.map.area(Winterfell).receive!(Footman.create_new(HouseStark))
    g.map.area(Winterfell).receive!(MarchOrder.new(HouseStark))
    g.change_game_period(:resolve_march_orders)

    e = assert_raises(RuntimeError) { g.execute_march_order!(Winterfell, { Winterfell => [Footman] }, true) }
    assert_equal('Cannot specify Establish Control when not vacating Winterfell', e.message)
    e = assert_raises(RuntimeError) { g.execute_march_order!(Winterfell, { Winterfell => [Footman] }, false) }
    assert_equal('Cannot specify Establish Control when not vacating Winterfell', e.message)
    e = assert_raises(RuntimeError) { g.execute_march_order!(Winterfell, { CastleBlack => [Footman] }, nil) }
    assert_equal('Must specify Establish Control when vacating Winterfell', e.message)

    power_token_count = g.house(HouseStark).count(PowerToken)
    g.execute_march_order!(Winterfell, { CastleBlack => [Footman] }, true)
    assert_equal(HouseStark, g.map.area(Winterfell).controlling_house_class)
    assert_equal(HouseStark, g.map.area(CastleBlack).controlling_house_class)
    assert_equal(power_token_count - 1, g.house(HouseStark).count(PowerToken))
  end

  def test_march_combat
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g.map = Map.create_new([])
    g.map.area(Winterfell).receive!(Footman.create_new(HouseStark))
    g.map.area(CastleBlack).receive!(Footman.create_new(HouseLannister))
    g.map.area(Winterfell).receive!(MarchOrder.new(HouseStark))
    g.change_game_period(:resolve_march_orders)

    assert_equal(nil, g.combat)
    g.execute_march_order!(Winterfell, { CastleBlack => [Footman] }, false)
    refute_equal(nil, g.combat)
  end

  def test_consolidate_power
    data = [
      { :area_class => KingsLanding, :expected_power => 3 },
      { :area_class => CastleBlack, :expected_power => 2 },
      { :area_class => TheShiveringSea, :expected_power => 1 },
      { :area_class => WinterfellPortToBayOfIce, :expected_power => 1 }
    ]
    data.each do |datum|
      g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
      power_before = g.house(HouseStark).count(PowerToken)
      g.map = Map.create_new([])
      token_class = datum[:area_class] < LandArea ? Footman : Ship
      g.map.area(datum[:area_class]).receive!(token_class.create_new(HouseStark))
      g.map.area(datum[:area_class]).receive!(ConsolidatePowerOrder.new(HouseStark))
      g.change_game_period(:resolve_consolidate_power_orders)
      g.execute_consolidate_power_order!(datum[:area_class])
      power_after = g.house(HouseStark).count(PowerToken)
      assert_equal(power_before + datum[:expected_power], power_after)
    end
  end

  def test_consolidate_power_in_port_with_adjacent_enemy_ships
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    power_before = g.house(HouseStark).count(PowerToken)
    g.map = Map.create_new
    g.map.area(WinterfellPortToBayOfIce).receive!(Ship.create_new(HouseStark))
    g.map.area(WinterfellPortToBayOfIce).receive!(ConsolidatePowerOrder.new(HouseStark))
    g.map.area(BayOfIce).receive!(Ship.create_new(HouseLannister))
    g.change_game_period(:resolve_consolidate_power_orders)
    g.execute_consolidate_power_order!(WinterfellPortToBayOfIce)
    power_after = g.house(HouseStark).count(PowerToken)
    assert_equal(power_before, power_after)
  end

  def test_clean_up
    g = GameController.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g.map = Map.create_new([])
    g.map.area(CastleBlack).receive!(Footman.new(HouseStark, false))
    g.map.area(CastleBlack).receive!(SupportOrder.new(HouseStark))
    g.map.area(Lannisport).receive!(Footman.new(HouseLannister, true))
    g.map.area(Lannisport).receive!(DefenseOrder.new(HouseLannister))
    g.clean_up!
    assert_equal(true, g.map.area(CastleBlack).has?(Footman))
    assert_equal(false, g.map.area(CastleBlack).has?(OrderToken))
    assert_equal(false, g.map.area(CastleBlack).get_all(Unit).any? { |unit| unit.routed })
    assert_equal(true, g.map.area(Lannisport).has?(Footman))
    assert_equal(false, g.map.area(Lannisport).has?(OrderToken))
    assert_equal(false, g.map.area(Lannisport).get_all(Unit).any? { |unit| unit.routed })
    assert_equal(false, g.messenger_raven_token.used)
    assert_equal(false, g.valyrian_steel_blade_token.used)
  end
end
