class TestGame < Test::Unit::TestCase
  def test_initialize_invalid
    # Game must be initialized with players
    assert_raise(ArgumentError) { Game.new }
    assert_raise(RuntimeError) { Game.new({}) }
    assert_raise(RuntimeError) { Game.new([]) }
  end

  def test_game_setup
    houses = [
      HouseStark.new,
      HouseLannister.new,
      HouseBaratheon.new,
      HouseGreyjoy.new,
      HouseTyrell.new,
      HouseMartell.new
    ]
    game = Game.new(houses)
    assert_equal(6, game.houses.length)
    assert_equal(1, game.game_round)
    assert_equal(:planning, game.round_phase)

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
      assert_equal(units_remaining[:footmen], house.units.count{ |unit| unit.is_a? Footman })
      assert_equal(units_remaining[:knights], house.units.count{ |unit| unit.is_a? Knight })
      assert_equal(units_remaining[:ships], house.units.count{ |unit| unit.is_a? Ship })
      assert_equal(units_remaining[:siege_engines], house.units.count{ |unit| unit.is_a? SiegeEngine })
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
      assert_equal(5, house.power_tokens.count, house.to_s + ' has wrong number of power tokens')
    end

    # Garrison tokens
    expected_garrison_token_locations = [Winterfell, Lannisport, Dragonstone, Pyke, Highgarden, Sunspear]
    actual_garrison_token_locations = game.map.areas.find_all { |area| area.has_token? (GarrisonToken) }.map { |area| area.class }
    assert_equal(expected_garrison_token_locations.to_set, actual_garrison_token_locations.to_set, 'Garrison tokens in wrong places')
  end

  def test_house_selection_valid
    data = [
      [HouseStark, HouseLannister, HouseBaratheon],
      [HouseMartell, HouseTyrell, HouseGreyjoy, HouseBaratheon, HouseLannister, HouseStark]
    ]
    data.each do |datum|
      assert_nothing_raised {
        houses = datum.map { |house_class| house_class.new }
        g = Game.new(houses)
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
      assert_raise(RuntimeError) {
        houses = datum.map { |house_class| house_class.new }
        g = Game.new(houses)
      }
    end
  end

  def test_place_units
    h1 = HouseStark.new
    h2 = HouseLannister.new
    h3 = HouseBaratheon.new
    houses = [h1, h2, h3]
    g = Game.new(houses)
    g.place_unit(CastleBlack, h1, Footman)
    g.place_unit(CastleBlack, h1, Footman)
    g.place_unit(CastleBlack, h1, Footman)
    g.place_unit(CastleBlack, h1, Footman)
    g.place_unit(CastleBlack, h1, Footman)
    g.place_unit(CastleBlack, h1, Footman)
    g.place_unit(CastleBlack, h1, Footman)
    g.place_unit(CastleBlack, h1, Footman)
    assert_raise(RuntimeError) { g.place_unit(CastleBlack, h1, Footman) }
  end
end
