class TestGame < Test::Unit::TestCase
  def test_initialize_invalid
    # Game must be initialized with players
    assert_raise(ArgumentError) { Game.new }
    assert_raise(RuntimeError) { Game.new({}) }
    assert_raise(RuntimeError) { Game.new([]) }
  end

  def test_game_setup
    players = [
      Player.new('a', HouseStark),
      Player.new('b', HouseLannister),
      Player.new('c', HouseBaratheon),
      Player.new('d', HouseGreyjoy),
      Player.new('e', HouseTyrell),
      Player.new('f', HouseMartell),
    ]
    game = Game.new(players)
    assert_equal(6, game.players.length)
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
      player = players.find { |player| player.house.class == house_class }
      assert_equal(units_remaining[:footmen], player.house.units.count{ |unit| unit.is_a? Footman })
      assert_equal(units_remaining[:knights], player.house.units.count{ |unit| unit.is_a? Knight })
      assert_equal(units_remaining[:ships], player.house.units.count{ |unit| unit.is_a? Ship })
      assert_equal(units_remaining[:siege_engines], player.house.units.count{ |unit| unit.is_a? SiegeEngine })
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
  end

  def test_house_selection_valid
    data = [
      [HouseStark, HouseLannister, HouseBaratheon],
      [HouseMartell, HouseTyrell, HouseGreyjoy, HouseBaratheon, HouseLannister, HouseStark]
    ]
    data.each do |datum|
      assert_nothing_raised {
        players = []
        datum.each do |house|
          players.push(Player.new(nil, house))
        end
        g = Game.new(players)
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
        players = []
        datum.each do |house|
          players.push(Player.new(nil, house))
        end
        g = Game.new(players)
      }
    end
  end

  def test_place_units
    p1 = Player.new('a', HouseStark)
    p2 = Player.new('b', HouseLannister)
    p3 = Player.new('c', HouseBaratheon)
    players = [p1, p2, p3]
    g = Game.new(players)
    g.place_unit(p1, Footman, CastleBlack)
    g.place_unit(p1, Footman, CastleBlack)
    g.place_unit(p1, Footman, CastleBlack)
    g.place_unit(p1, Footman, CastleBlack)
    g.place_unit(p1, Footman, CastleBlack)
    g.place_unit(p1, Footman, CastleBlack)
    g.place_unit(p1, Footman, CastleBlack)
    g.place_unit(p1, Footman, CastleBlack)
    assert_raise(RuntimeError) { g.place_unit(p1, Footman, CastleBlack) }
  end
end
