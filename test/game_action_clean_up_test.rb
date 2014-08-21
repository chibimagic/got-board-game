class GameActionCleanUpTest < MiniTest::Test
  def test_clean_up
    g = Game.create_new([HouseStark, HouseLannister, HouseBaratheon])
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
