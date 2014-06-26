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
      0 => [].to_set,
      1 => [HouseStark].to_set,
      2 => [HouseLannister, HouseBaratheon, HouseGreyjoy, HouseTyrell, HouseMartell].to_set,
      3 => [].to_set,
      4 => [].to_set,
      5 => [].to_set,
      6 => [].to_set
    }
    expected_supply.each do |supply_level, houses|
      assert_equal(houses, game.map.houses_with_supply(supply_level), 'Houses with supply ' + supply_level.to_s + ' should be: ' + houses.to_a.join(', '))
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
    g.place_unit(h1, Footman, CastleBlack)
    g.place_unit(h1, Footman, CastleBlack)
    g.place_unit(h1, Footman, CastleBlack)
    g.place_unit(h1, Footman, CastleBlack)
    g.place_unit(h1, Footman, CastleBlack)
    g.place_unit(h1, Footman, CastleBlack)
    g.place_unit(h1, Footman, CastleBlack)
    g.place_unit(h1, Footman, CastleBlack)
    assert_raise(RuntimeError) { g.place_unit(h1, Footman, CastleBlack) }
  end
end
