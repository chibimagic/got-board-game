class TestUnit < MiniTest::Test
  def test_equality
    assert_equal(Footman.create_new(HouseStark), Footman.create_new(HouseStark))
    refute_equal(Footman.create_new(HouseStark), Footman.create_new(HouseLannister))
    refute_equal(Footman.create_new(HouseStark), Knight.create_new(HouseStark))
    refute_equal(Unit.create_new(HouseStark), Footman.create_new(HouseStark))
  end
end
