class TestGameActionCleanUp < MiniTest::Test
  def test_clean_up
    g = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    g.map = Map.create_new([])
    g.map.area(CastleBlack).receive_token!(Footman.new(HouseStark, false))
    g.map.area(CastleBlack).receive_token!(SupportOrder.new(HouseStark))
    g.map.area(Lannisport).receive_token!(Footman.new(HouseLannister, true))
    g.map.area(Lannisport).receive_token!(DefenseOrder.new(HouseLannister))
    g.clean_up!
    assert_equal(true, g.map.area(CastleBlack).has_token?(Footman))
    assert_equal(false, g.map.area(CastleBlack).has_token?(OrderToken))
    assert_equal(false, g.map.area(CastleBlack).get_tokens(Unit).any? { |unit| unit.routed })
    assert_equal(true, g.map.area(Lannisport).has_token?(Footman))
    assert_equal(false, g.map.area(Lannisport).has_token?(OrderToken))
    assert_equal(false, g.map.area(Lannisport).get_tokens(Unit).any? { |unit| unit.routed })
    assert_equal(false, g.messenger_raven_token.used)
    assert_equal(false, g.valyrian_steel_blade_token.used)
  end
end
