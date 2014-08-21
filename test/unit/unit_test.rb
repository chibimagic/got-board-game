class UnitTest < MiniTest::Test
  def test_equality
    assert_equal(Footman.create_new(HouseStark), Footman.create_new(HouseStark))
    refute_equal(Footman.create_new(HouseStark), Footman.create_new(HouseLannister))
    refute_equal(Footman.create_new(HouseStark), Knight.create_new(HouseStark))
    refute_equal(Unit.create_new(HouseStark), Footman.create_new(HouseStark))
  end

  def test_combat_strength
    assert_equal(1, Footman.create_new(HouseStark).combat_strength(nil))
    assert_equal(1, Footman.create_new(HouseStark).combat_strength(CastleBlack))
    assert_equal(1, Footman.create_new(HouseStark).combat_strength(Winterfell))

    assert_equal(2, Knight.create_new(HouseStark).combat_strength(nil))
    assert_equal(2, Knight.create_new(HouseStark).combat_strength(CastleBlack))
    assert_equal(2, Knight.create_new(HouseStark).combat_strength(Winterfell))

    assert_equal(1, Ship.create_new(HouseStark).combat_strength(nil))
    assert_equal(1, Ship.create_new(HouseStark).combat_strength(CastleBlack))
    assert_equal(1, Ship.create_new(HouseStark).combat_strength(Winterfell))

    assert_equal(0, SiegeEngine.create_new(HouseStark).combat_strength(nil))
    assert_equal(0, SiegeEngine.create_new(HouseStark).combat_strength(CastleBlack))
    assert_equal(4, SiegeEngine.create_new(HouseStark).combat_strength(Winterfell))
  end
end
