class TestPowerPool < MiniTest::Test
  def test_equality
    p1 = PowerPool.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    p2 = PowerPool.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    p3 = PowerPool.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new, HouseGreyjoy.create_new])
    assert_equal(p1, p2)

    t1 = p1.pool.find { |token| token.house_class == HouseStark }
    p1.remove_token(t1)
    refute_equal(p1, p2)

    t2 = p2.pool.find { |token| token.house_class == HouseStark }
    p2.remove_token(t2)
    assert_equal(p1, p2)
  end

  def test_count
    h1 = HouseStark.create_new
    h2 = HouseLannister.create_new
    h3 = HouseBaratheon.create_new
    h4 = HouseGreyjoy.create_new
    h5 = HouseTyrell.create_new
    h6 = HouseMartell.create_new

    p = PowerPool.create_new([h1, h2, h3])
    assert_equal(45, p.pool.count, 'Wrong number of tokens for 3 houses')
    p = PowerPool.create_new([h1, h2, h3, h4])
    assert_equal(60, p.pool.count, 'Wrong number of tokens for 3 houses')
    p = PowerPool.create_new([h1, h2, h3, h4, h5])
    assert_equal(75, p.pool.count, 'Wrong number of tokens for 3 houses')
    p = PowerPool.create_new([h1, h2, h3, h4, h5, h6])
    assert_equal(90, p.pool.count, 'Wrong number of tokens for 3 houses')
  end
end
