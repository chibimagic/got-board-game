class TestGame < MiniTest::Test
  def test_new_invalid
    e = assert_raises(ArgumentError) { Game.new }
    assert_equal('wrong number of arguments (0 for 20)', e.message)
    e = assert_raises(ArgumentError) { Game.new([HouseStark, HouseLannister, HouseBaratheon]) }
    assert_equal('wrong number of arguments (1 for 20)', e.message)
  end

  def test_new_game_invalid
    # Game must be initialized with players
    e = assert_raises(ArgumentError) { Game.create_new }
    assert_equal('wrong number of arguments (0 for 1)', e.message)
    e = assert_raises(RuntimeError) { Game.create_new({}) }
    assert_equal('Need an array of house classes', e.message)
    e = assert_raises(RuntimeError) { Game.create_new([]) }
    assert_equal('Cannot play A Game of Thrones (second edition) with 0 players', e.message)
  end

  def test_game_setup
    house_classes = [HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy, HouseTyrell, HouseMartell]
    game = Game.create_new(house_classes)
    assert_equal(6, game.houses.length)
    assert_equal(1, game.round)
    assert_equal(:assign_orders, game.game_period)
    assert_equal('Planning phase, Assign Orders step', game.game_period_string)
    assert_equal([HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy, HouseTyrell, HouseMartell], game.players_turn)
    assert_equal(false, game.valyrian_steel_blade_token.used)
    assert_equal(false, game.messenger_raven_token.used)

    expected_units_remaining = {
      HouseStark => { :footmen => 8, :knights => 4, :ships => 5, :siege_engines => 2 },
      HouseLannister => { :footmen => 8, :knights => 4, :ships => 5, :siege_engines => 2 },
      HouseBaratheon => { :footmen => 8, :knights => 4, :ships => 4, :siege_engines => 2 },
      HouseGreyjoy => { :footmen => 8, :knights => 4, :ships => 4, :siege_engines => 2 },
      HouseTyrell => { :footmen => 8, :knights => 4, :ships => 5, :siege_engines => 2 },
      HouseMartell => { :footmen => 8, :knights => 4, :ships => 5, :siege_engines => 2 },
    }
    expected_units_remaining.each do |house_class, units_remaining|
      house = game.houses.find { |house| house.class == house_class }
      assert_equal(units_remaining[:footmen], house.count_tokens(Footman))
      assert_equal(units_remaining[:knights], house.count_tokens(Knight))
      assert_equal(units_remaining[:ships], house.count_tokens(Ship))
      assert_equal(units_remaining[:siege_engines], house.count_tokens(SiegeEngine))
    end

    # All houses except House Stark begin at supply = 2
    expected_supply = {
      0 => [],
      1 => [HouseStark],
      2 => [HouseLannister, HouseBaratheon, HouseGreyjoy, HouseTyrell, HouseMartell],
      3 => [],
      4 => [],
      5 => [],
      6 => []
    }
    expected_supply.each do |supply_level, houses|
      assert_equal(houses.to_set, game.map.houses(supply_level).to_set, 'Houses with supply ' + supply_level.to_s + ' should be: ' + houses.to_a.join(', '))
    end
    houses = [HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy, HouseTyrell, HouseMartell]
    houses.each do |house_class|
      assert_equal(house_class::INITIAL_SUPPLY, game.map.supply_level(house_class))
    end

    # All houses start with 3 controlled areas, except House Greyjoy
    Game::HOUSE_CLASSES.each do |house_class|
      expected_controlled_areas = house_class == HouseGreyjoy ? 4 : 3
      assert_equal(expected_controlled_areas, game.map.controlled_areas(house_class).count, house_class.to_s + ' controls wrong number of areas')
    end

    # Neutral tokens in a 6 player game
    area_classes = game.map.controlled_areas(HouseIndependent).map { |area| area.class }
    assert_equal([KingsLanding, TheEyrie], area_classes, 'Wrong neutral tokens')

    assert_equal(90, game.power_pool.tokens.count, 'Wrong number of tokens in power pool')
    game.houses.each do |house|
      assert_equal(5, house.count_tokens(PowerToken), house.to_s + ' has wrong number of power tokens')
    end

    # Garrison tokens
    expected_garrison_token_locations = [Winterfell, Lannisport, Dragonstone, Pyke, Highgarden, Sunspear]
    actual_garrison_token_locations = game.map.areas.find_all { |area| area.has_token?(GarrisonToken) }.map { |area| area.class }
    assert_equal(expected_garrison_token_locations.to_set, actual_garrison_token_locations.to_set, 'Garrison tokens in wrong places')
  end

  def test_serialize
    original_game = Game.create_new([HouseStark, HouseLannister, HouseBaratheon])
    stored_game = original_game.serialize.to_json
    restored_game = Game.unserialize(JSON.parse(stored_game))
    assert_equal(original_game, restored_game)
  end

  def test_equality
    # Different decks will make the games unequal
    g1 = Game.create_new([HouseStark, HouseLannister, HouseBaratheon])
    g2 = Game.create_new([HouseStark, HouseLannister, HouseBaratheon])
    refute_equal(g1, g2)
  end

  def test_marshal_equality
    original_game = Game.create_new([HouseStark, HouseLannister, HouseBaratheon])
    restored_game = Marshal.load(Marshal.dump(original_game))
    assert_equal(original_game, restored_game)
  end

  def test_house_selection_valid
    data = [
      [HouseStark, HouseLannister, HouseBaratheon],
      [HouseMartell, HouseTyrell, HouseGreyjoy, HouseBaratheon, HouseLannister, HouseStark]
    ]
    data.each do |datum|
      refute_raises { g = Game.create_new(datum) }
    end
  end

  def test_house_selection_invalid
    data = [
      # Can't choose the same house more than once
      [HouseStark, HouseStark, HouseStark],
      [HouseStark, HouseStark, HouseLannister],
      [HouseStark, HouseLannister, HouseStark],
      # Can't choose House Greyjoy/Tyrell/Martell in a 3 player game
      [HouseStark, HouseLannister, HouseGreyjoy],
      [HouseStark, HouseLannister, HouseTyrell],
      [HouseStark, HouseLannister, HouseMartell],
      # Can't choose House Tyrell/Martell in a 4 player game
      [HouseStark, HouseLannister, HouseBaratheon, HouseTyrell],
      [HouseStark, HouseLannister, HouseBaratheon, HouseMartell],
      # Can't choose House Martell in a 5 player game
      [HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy, HouseMartell]
    ]
    data.each do |datum|
      assert_raises(RuntimeError) {
        g = Game.create_new(datum)
      }
    end
  end

  def test_game_period_players_turn
    g = Game.create_new([HouseStark, HouseLannister, HouseBaratheon])

    assert_equal(:assign_orders, g.game_period)
    assert_equal('Planning phase, Assign Orders step', g.game_period_string)
    assert_equal([HouseStark, HouseLannister, HouseBaratheon].to_set, g.players_turn.to_set)
    g.place_order!(HouseStark, Winterfell, RaidOrder)
    g.place_order!(HouseLannister, Lannisport, RaidOrder)
    g.place_order!(HouseBaratheon, Dragonstone, RaidOrder)
    g.place_order!(HouseStark, WhiteHarbor, MarchOrder)
    g.place_order!(HouseLannister, StoneySept, MarchOrder)
    g.place_order!(HouseBaratheon, Kingswood, MarchOrder)
    g.place_order!(HouseStark, TheShiveringSea, ConsolidatePowerOrder)
    g.place_order!(HouseLannister, TheGoldenSound, ConsolidatePowerOrder)
    g.place_order!(HouseBaratheon, ShipbreakerBay, ConsolidatePowerOrder)

    assert_equal(:messenger_raven, g.game_period)
    assert_equal('Planning phase, Messenger Raven step', g.game_period_string)
    assert_equal([HouseLannister], g.players_turn)
    g.skip_messenger_raven

    assert_equal(:resolve_raid_orders, g.game_period)
    assert_equal('Action phase, Resolve Raid Orders step', g.game_period_string)
    assert_equal([HouseBaratheon], g.players_turn)
    g.execute_raid_order!(Dragonstone, nil)
    assert_equal([HouseLannister], g.players_turn)
    g.execute_raid_order!(Lannisport, nil)
    assert_equal([HouseStark], g.players_turn)
    g.execute_raid_order!(Winterfell, nil)

    assert_equal(:resolve_march_orders, g.game_period)
    assert_equal('Action phase, Resolve March Orders step', g.game_period_string)
    assert_equal([HouseBaratheon], g.players_turn)
    g.execute_march_order!(Kingswood, { Kingswood => [Footman] }, nil)
    assert_equal([HouseLannister], g.players_turn)
    g.execute_march_order!(StoneySept, { StoneySept => [Footman] }, nil)
    assert_equal([HouseStark], g.players_turn)
    g.execute_march_order!(WhiteHarbor, { WhiteHarbor => [Footman] }, nil)

    assert_equal(:resolve_consolidate_power_orders, g.game_period)
    assert_equal('Action phase, Resolve Consolidate Power Orders step', g.game_period_string)
    assert_equal([HouseBaratheon], g.players_turn)
    g.execute_consolidate_power_order!(ShipbreakerBay)
    assert_equal([HouseLannister], g.players_turn)
    g.execute_consolidate_power_order!(TheGoldenSound)
    assert_equal([HouseStark], g.players_turn)
    g.execute_consolidate_power_order!(TheShiveringSea)

    assert_equal(:westeros, g.game_period)
    assert_equal('Westeros phase', g.game_period_string)
    assert_equal([], g.players_turn)
  end
end
