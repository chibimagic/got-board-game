class TestGame < MiniTest::Test
  def test_new_invalid
    e = assert_raises(ArgumentError) { Game.new }
    assert_equal('wrong number of arguments (0 for 15)', e.message)
    e = assert_raises(ArgumentError) { Game.new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new]) }
    assert_equal('wrong number of arguments (1 for 15)', e.message)
  end

  def test_new_game_invalid
    # Game must be initialized with players
    e = assert_raises(ArgumentError) { Game.create_new }
    assert_equal('wrong number of arguments (0 for 1)', e.message)
    e = assert_raises(RuntimeError) { Game.create_new({}) }
    assert_equal('Need an array of houses', e.message)
    e = assert_raises(RuntimeError) { Game.create_new([]) }
    assert_equal('A Game of Thrones (second edition) can only be played with 3-6 players, not 0', e.message)
  end

  def test_game_setup
    houses = [
      HouseStark.create_new,
      HouseLannister.create_new,
      HouseBaratheon.create_new,
      HouseGreyjoy.create_new,
      HouseTyrell.create_new,
      HouseMartell.create_new
    ]
    game = Game.create_new(houses)
    assert_equal(6, game.houses.length)
    assert_equal(1, game.game_state.round)
    assert_equal(:assign_orders, game.game_state.game_period)
    assert_equal('Planning', game.game_state.phase)
    assert_equal('Assign Orders', game.game_state.step)
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
      house = houses.find { |house| house.class == house_class }
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
      assert_equal(houses.to_set, game.map.houses_with_supply(supply_level).to_set, 'Houses with supply ' + supply_level.to_s + ' should be: ' + houses.to_a.join(', '))
    end
    houses = [HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy, HouseTyrell, HouseMartell]
    houses.each do |house_class|
      assert_equal(house_class::INITIAL_SUPPLY, game.map.supply_level(house_class))
    end

    # All houses start with 3 controlled areas
    Houses.new.each do |house_class|
      assert_equal(3, game.map.controlled_areas(house_class).count, house_class.to_s + ' controls wrong number of areas')
    end

    # Neutral tokens in a 6 player game
    area_classes = game.map.controlled_areas(HouseIndependent).map { |area| area.class }
    assert_equal([KingsLanding, TheEyrie], area_classes, 'Wrong neutral tokens')

    assert_equal(90, game.power_pool.pool.count, 'Wrong number of tokens in power pool')
    game.houses.each do |house|
      assert_equal(5, house.count_tokens(PowerToken), house.to_s + ' has wrong number of power tokens')
    end

    # Garrison tokens
    expected_garrison_token_locations = [Winterfell, Lannisport, Dragonstone, Pyke, Highgarden, Sunspear]
    actual_garrison_token_locations = game.map.areas.find_all { |area| area.has_token?(GarrisonToken) }.map { |area| area.class }
    assert_equal(expected_garrison_token_locations.to_set, actual_garrison_token_locations.to_set, 'Garrison tokens in wrong places')
  end

  def test_serialize
    original_game = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    stored_game = original_game.serialize.to_json
    restored_game = Game.unserialize(JSON.parse(stored_game))
    assert_equal(original_game, restored_game)
  end

  def test_equality
    # Different decks will make the games unequal
    g1 = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    g2 = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    refute_equal(g1, g2)
  end

  def test_marshal_equality
    original_game = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    restored_game = Marshal.load(Marshal.dump(original_game))
    assert_equal(original_game, restored_game)
  end

  def test_house_selection_valid
    data = [
      [HouseStark, HouseLannister, HouseBaratheon],
      [HouseMartell, HouseTyrell, HouseGreyjoy, HouseBaratheon, HouseLannister, HouseStark]
    ]
    data.each do |datum|
      refute_raises {
        houses = datum.map { |house_class| house_class.create_new }
        g = Game.create_new(houses)
      }
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
        houses = datum.map { |house_class| house_class.create_new }
        g = Game.create_new(houses)
      }
    end
  end

  def test_place_units
    g = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    g.place_token(HouseStark, CastleBlack, Footman)
    g.place_token(HouseStark, CastleBlack, Footman)
    g.place_token(HouseStark, CastleBlack, Footman)
    g.place_token(HouseStark, CastleBlack, Footman)
    g.place_token(HouseStark, CastleBlack, Footman)
    g.place_token(HouseStark, CastleBlack, Footman)
    g.place_token(HouseStark, CastleBlack, Footman)
    g.place_token(HouseStark, CastleBlack, Footman)
    e = assert_raises(RuntimeError) { g.place_token(HouseStark, CastleBlack, Footman) }
    assert_equal('House Stark (no name) has no Footman', e.message)
  end

  def test_place_orders
    g = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    e = assert_raises(RuntimeError) { g.place_token(HouseStark, CastleBlack, MarchOrder) }
    assert_equal('Cannot place March Order (House Stark) because Castle Black (0) has no units', e.message)
    e = assert_raises(RuntimeError) { g.place_token(HouseLannister, Winterfell, MarchOrder) }
    assert_equal('Cannot place March Order (House Lannister) because Winterfell (3) is controlled by House Stark', e.message)
    refute_raises { g.place_token(HouseStark, TheShiveringSea, MarchOrder) }
  end

  def test_special_orders
    g = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    assert_equal(1, g.kings_court_track.special_orders_allowed(HouseBaratheon))
    refute_raises { g.place_token(HouseBaratheon, ShipbreakerBay, MarchOrder) }
    refute_raises { g.place_token(HouseBaratheon, Dragonstone, SpecialDefenseOrder) }
    e = assert_raises(RuntimeError) { g.place_token(HouseBaratheon, Dragonstone, SpecialMarchOrder) }
    assert_equal('House Baratheon can only place 1 special order', e.message)
  end

  def test_orders_in
    g = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    assert_equal('Assign Orders', g.game_state.step)
    g.place_token(HouseStark, TheShiveringSea, WeakMarchOrder)
    g.place_token(HouseStark, WhiteHarbor, MarchOrder)
    g.place_token(HouseStark, Winterfell, DefenseOrder)
    g.place_token(HouseLannister, TheGoldenSound, WeakMarchOrder)
    g.place_token(HouseLannister, Lannisport, MarchOrder)
    g.place_token(HouseLannister, StoneySept, DefenseOrder)
    g.place_token(HouseBaratheon, ShipbreakerBay, WeakMarchOrder)
    g.place_token(HouseBaratheon, Dragonstone, MarchOrder)
    g.place_token(HouseBaratheon, Kingswood, DefenseOrder)
    assert_equal('Messenger Raven', g.game_state.step)
    e = assert_raises(RuntimeError) { g.place_token(HouseStark, TheShiveringSea, SpecialMarchOrder) }
    assert_match(/^Cannot place March Order \(House Stark\) during .* Planning phase, Messenger Raven step$/, e.message)
  end

  def test_replace_order
    g = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    e = assert_raises(RuntimeError) { g.replace_order(CastleBlack, WeakMarchOrder) }
    assert_match(/^Cannot replace order during .* Assign Orders step$/, e.message)

    g.place_token(HouseStark, TheShiveringSea, WeakMarchOrder)
    g.place_token(HouseStark, WhiteHarbor, MarchOrder)
    g.place_token(HouseStark, Winterfell, DefenseOrder)
    g.place_token(HouseLannister, TheGoldenSound, WeakMarchOrder)
    g.place_token(HouseLannister, Lannisport, MarchOrder)
    g.place_token(HouseLannister, StoneySept, DefenseOrder)
    g.place_token(HouseBaratheon, ShipbreakerBay, WeakMarchOrder)
    g.place_token(HouseBaratheon, Dragonstone, MarchOrder)
    g.place_token(HouseBaratheon, Kingswood, DefenseOrder)

    e = assert_raises(RuntimeError) { g.replace_order(CastleBlack, WeakMarchOrder) }
    assert_equal('Castle Black (0) has no Order Token', e.message)
    e = assert_raises(RuntimeError) { g.replace_order(Winterfell, WeakMarchOrder) }
    assert_equal('Only the holder of the Messenger Raven token may replace an order', e.message)
    e = assert_raises(RuntimeError) { g.replace_order(Lannisport, WeakMarchOrder) }
    assert_equal('House Lannister (no name) has no March Order', e.message)

    refute_raises { g.replace_order(Lannisport, RaidOrder) }

    e = assert_raises(RuntimeError) { g.replace_order(Lannisport, RaidOrder) }
    assert_match(/^Cannot replace order during .* Resolve Raid Orders step$/, e.message)
  end

  def test_use_messenger_raven
    g = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    g.place_token(HouseStark, TheShiveringSea, WeakMarchOrder)
    g.place_token(HouseStark, WhiteHarbor, MarchOrder)
    g.place_token(HouseStark, Winterfell, DefenseOrder)
    g.place_token(HouseLannister, TheGoldenSound, WeakMarchOrder)
    g.place_token(HouseLannister, Lannisport, MarchOrder)
    g.place_token(HouseLannister, StoneySept, DefenseOrder)
    g.place_token(HouseBaratheon, ShipbreakerBay, WeakMarchOrder)
    g.place_token(HouseBaratheon, Dragonstone, MarchOrder)
    g.place_token(HouseBaratheon, Kingswood, DefenseOrder)

    assert_equal(:messenger_raven, g.game_state.game_period)
    card = g.look_at_wildling_deck
    assert_equal(:messenger_raven, g.game_state.game_period)
    e = assert_raises(RuntimeError) { g.look_at_wildling_deck }
    assert_equal('Messenger Raven token has already been used', e.message)
    assert_equal(:messenger_raven, g.game_state.game_period)
    e = assert_raises(RuntimeError) { g.skip_messenger_raven }
    assert_equal('Messenger Raven token has already been used', e.message)
    assert_equal(:messenger_raven, g.game_state.game_period)
    e = assert_raises(RuntimeError) { g.replace_order(Lannisport, RaidOrder) }
    assert_equal('Messenger Raven token has already been used', e.message)
    assert_equal(:messenger_raven, g.game_state.game_period)
    refute_raises { g.replace_wildling_card_top(card) }
  end
end
