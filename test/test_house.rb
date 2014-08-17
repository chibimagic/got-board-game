class TestHouse < MiniTest::Test
  def setup
    house_classes = [HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy, HouseTyrell, HouseMartell]
    @houses = house_classes.map { |house_class| house_class.create_new }
  end

  def test_serialize
    original_house = HouseStark.create_new
    stored_house = original_house.serialize.to_json
    restored_house = HouseStark.unserialize(JSON.parse(stored_house))
    assert_equal(original_house, restored_house)
  end

  def test_equality
    assert_equal(HouseStark.create_new, HouseStark.create_new)
    refute_equal(HouseStark.create_new, HouseLannister.create_new)
  end

  def test_units
    @houses.each do |house|
      assert_equal(10, house.count(Footman))
      assert_equal(5, house.count(Knight))
      assert_equal(6, house.count(Ship))
      assert_equal(2, house.count(SiegeEngine))
    end
  end

  def test_power_tokens
    @houses.each do |house|
      assert_equal(5, house.count(PowerToken))
    end
  end
end
