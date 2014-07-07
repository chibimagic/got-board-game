class TestPowerPool < MiniTest::Test
  def test_equality
    p1 = PowerPool.new([HouseStark.new, HouseLannister.new, HouseBaratheon.new])
    p2 = PowerPool.new([HouseStark.new, HouseLannister.new, HouseBaratheon.new])
    p3 = PowerPool.new([HouseStark.new, HouseLannister.new, HouseBaratheon.new, HouseGreyjoy.new])
    assert_equal(p1, p2)

    t1 = p1.pool.find { |token| token.house_class == HouseStark }
    p1.remove_token(t1)
    refute_equal(p1, p2)

    t2 = p2.pool.find { |token| token.house_class == HouseStark }
    p2.remove_token(t2)
    assert_equal(p1, p2)
  end

  def test_count
    h1 = HouseStark.new
    h2 = HouseLannister.new
    h3 = HouseBaratheon.new
    h4 = HouseGreyjoy.new
    h5 = HouseTyrell.new
    h6 = HouseMartell.new

    p = PowerPool.new([h1, h2, h3])
    assert_equal(45, p.pool.count, 'Wrong number of tokens for 3 houses')
    p = PowerPool.new([h1, h2, h3, h4])
    assert_equal(60, p.pool.count, 'Wrong number of tokens for 3 houses')
    p = PowerPool.new([h1, h2, h3, h4, h5])
    assert_equal(75, p.pool.count, 'Wrong number of tokens for 3 houses')
    p = PowerPool.new([h1, h2, h3, h4, h5, h6])
    assert_equal(90, p.pool.count, 'Wrong number of tokens for 3 houses')
  end
end
