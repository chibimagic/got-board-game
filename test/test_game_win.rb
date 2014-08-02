class TestGameWin < MiniTest::Test
  def test_victory_point_win
    g = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    g.map = Map.create_new([])
    g.map.area(Winterfell).receive_token!(Footman.create_new(HouseStark)) # 1 VP
    g.map.area(WhiteHarbor).receive_token!(Footman.create_new(HouseStark)) # 1 VP
    g.map.area(Lannisport).receive_token!(Footman.create_new(HouseLannister)) # 1 VP
    g.map.area(Dragonstone).receive_token!(Footman.create_new(HouseBaratheon)) # 1 VP
    assert_equal(HouseStark, g.determine_winner)
  end

  def test_stronghold_win
    g = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    g.map = Map.create_new([])
    g.map.area(Winterfell).receive_token!(Footman.create_new(HouseStark)) # 1 VP, 1 stronghold
    g.map.area(WhiteHarbor).receive_token!(Footman.create_new(HouseStark)) # 1 VP
    g.map.area(Lannisport).receive_token!(Footman.create_new(HouseLannister)) # 1 VP, 1 stronghold
    g.map.area(Harrenhal).receive_token!(Footman.create_new(HouseLannister)) # 1 VP
    g.map.area(Dragonstone).receive_token!(Footman.create_new(HouseBaratheon)) # 1 VP, 1 stronghold
    g.map.area(KingsLanding).receive_token!(Footman.create_new(HouseBaratheon)) # 1 VP, 1 stronghold
    assert_equal(HouseBaratheon, g.determine_winner)
  end

  def test_supply_win
    g = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    g.map = Map.create_new([])
    g.map.area(Winterfell).receive_token!(Footman.create_new(HouseStark)) # 1 VP, 1 stronghold
    g.map.area(Lannisport).receive_token!(Footman.create_new(HouseLannister)) # 1 VP, 1 stronghold
    g.map.area(Dragonstone).receive_token!(Footman.create_new(HouseBaratheon)) # 1 VP, 1 stronghold
    g.supply_track.set_level(HouseStark, 1)
    g.supply_track.set_level(HouseLannister, 2)
    g.supply_track.set_level(HouseBaratheon, 1)
    assert_equal(HouseLannister, g.determine_winner)
  end

  def test_power_win
    g = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    g.map = Map.create_new([])
    g.map.area(Winterfell).receive_token!(Footman.create_new(HouseStark)) # 1 VP, 1 stronghold
    g.map.area(Lannisport).receive_token!(Footman.create_new(HouseLannister)) # 1 VP, 1 stronghold
    g.map.area(Dragonstone).receive_token!(Footman.create_new(HouseBaratheon)) # 1 VP, 1 stronghold
    g.supply_track.set_level(HouseStark, 1)
    g.supply_track.set_level(HouseLannister, 1)
    g.supply_track.set_level(HouseBaratheon, 1)
    g.house(HouseStark).receive_token(PowerToken.new(HouseStark)) # 1 power
    assert_equal(HouseStark, g.determine_winner)
  end

  def test_iron_throne_win
    g = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    g.map = Map.create_new([])
    g.map.area(Winterfell).receive_token!(Footman.create_new(HouseStark)) # 1 VP, 1 stronghold
    g.map.area(Lannisport).receive_token!(Footman.create_new(HouseLannister)) # 1 VP, 1 stronghold
    g.map.area(Dragonstone).receive_token!(Footman.create_new(HouseBaratheon)) # 1 VP, 1 stronghold
    assert_equal(HouseBaratheon, g.determine_winner)
  end
end
