class TestHouse < Test::Unit::TestCase
  def test_units
    houses = [HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy, HouseTyrell, HouseMartell]
    houses.each do |house_class|
      h = house_class.new
      assert_equal(10, h.units.count { |unit| unit.is_a? Footman })
      assert_equal(5, h.units.count { |unit| unit.is_a? Knight })
      assert_equal(6, h.units.count { |unit| unit.is_a? Ship })
      assert_equal(2, h.units.count { |unit| unit.is_a? SiegeEngine })
    end
  end
end
