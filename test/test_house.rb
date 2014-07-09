class TestHouse < MiniTest::Test
  def setup
    house_classes = [HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy, HouseTyrell, HouseMartell]
    @houses = house_classes.map { |house_class| house_class.create_new }
  end

  def test_equality
    assert_equal(HouseStark.create_new, HouseStark.create_new)
    assert_equal(HouseStark.create_new('a'), HouseStark.create_new('a'))
    refute_equal(HouseStark.create_new('a'), HouseStark.create_new('b'))
    refute_equal(HouseStark.create_new, HouseLannister.create_new)
    refute_equal(HouseStark.create_new('a'), HouseLannister.create_new('a'))
  end

  def test_units
    @houses.each do |house|
      assert_equal(10, house.units.count { |unit| unit.is_a?(Footman) })
      assert_equal(5, house.units.count { |unit| unit.is_a?(Knight) })
      assert_equal(6, house.units.count { |unit| unit.is_a?(Ship) })
      assert_equal(2, house.units.count { |unit| unit.is_a?(SiegeEngine) })
    end
  end

  def test_power_tokens
    @houses.each do |house|
      assert_equal(5, house.power_tokens.count)
    end
  end
end
