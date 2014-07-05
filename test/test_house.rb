class TestHouse < MiniTest::Test
  def setup
    house_classes = [HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy, HouseTyrell, HouseMartell]
    @houses = house_classes.map { |house_class| house_class.new }
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
