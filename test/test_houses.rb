class TestHouses < MiniTest::Test
  def test_find_house
    assert_equal(HouseStark, Houses.get_house_class("House Stark"))
    assert_equal(HouseLannister, Houses.get_house_class("House Lannister"))
    assert_equal(HouseBaratheon, Houses.get_house_class("House Baratheon"))
    assert_equal(HouseGreyjoy, Houses.get_house_class("House Greyjoy"))
    assert_equal(HouseTyrell, Houses.get_house_class("House Tyrell"))
    assert_equal(HouseMartell, Houses.get_house_class("House Martell"))
    assert_raises(RuntimeError) { Houses.get_house_class("house stark") }
    assert_raises(RuntimeError) { Houses.get_house_class("house lannister") }
    assert_raises(RuntimeError) { Houses.get_house_class("house baratheon") }
    assert_raises(RuntimeError) { Houses.get_house_class("house greyjoy") }
    assert_raises(RuntimeError) { Houses.get_house_class("house tyrell") }
    assert_raises(RuntimeError) { Houses.get_house_class("house martell") }
    assert_raises(RuntimeError) { Houses.get_house_class("HouseStark") }
    assert_raises(RuntimeError) { Houses.get_house_class("HouseLannister") }
    assert_raises(RuntimeError) { Houses.get_house_class("HouseBaratheon") }
    assert_raises(RuntimeError) { Houses.get_house_class("HouseGreyjoy") }
    assert_raises(RuntimeError) { Houses.get_house_class("HouseTyrell") }
    assert_raises(RuntimeError) { Houses.get_house_class("HouseMartell") }
    assert_raises(RuntimeError) { Houses.get_house_class("Stark") }
    assert_raises(RuntimeError) { Houses.get_house_class("Lannister") }
    assert_raises(RuntimeError) { Houses.get_house_class("Baratheon") }
    assert_raises(RuntimeError) { Houses.get_house_class("Greyjoy") }
    assert_raises(RuntimeError) { Houses.get_house_class("Tyrell") }
    assert_raises(RuntimeError) { Houses.get_house_class("Martell") }
  end
end
