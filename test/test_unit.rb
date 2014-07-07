class TestUnit < MiniTest::Test
  def test_equality
    assert_equal(Footman.new(HouseStark), Footman.new(HouseStark))
    refute_equal(Footman.new(HouseStark), Footman.new(HouseLannister))
    refute_equal(Footman.new(HouseStark), Knight.new(HouseStark))
    refute_equal(Unit.new(HouseStark), Footman.new(HouseStark))
  end
end
