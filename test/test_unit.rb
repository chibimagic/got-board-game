class TestUnit < MiniTest::Test
  def test_equality
    assert_equal(Footman.new(HouseStark.new), Footman.new(HouseStark.new))
    refute_equal(Footman.new(HouseStark.new), Footman.new(HouseLannister.new))
    refute_equal(Footman.new(HouseStark.new), Knight.new(HouseStark.new))
    refute_equal(Unit.new(HouseStark.new), Footman.new(HouseStark.new))
  end
end
