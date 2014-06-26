class TestPowerPool < Test::Unit::TestCase
  def test_count
    h1 = HouseStark.new
    h2 = HouseLannister.new
    h3 = HouseBaratheon.new
    h4 = HouseGreyjoy.new
    h5 = HouseTyrell.new
    h6 = HouseMartell.new

    p = PowerPool.new([h1, h2, h3])
    assert_equal(60, p.pool.count, 'Wrong number of tokens for 3 houses')
    p = PowerPool.new([h1, h2, h3, h4])
    assert_equal(80, p.pool.count, 'Wrong number of tokens for 3 houses')
    p = PowerPool.new([h1, h2, h3, h4, h5])
    assert_equal(100, p.pool.count, 'Wrong number of tokens for 3 houses')
    p = PowerPool.new([h1, h2, h3, h4, h5, h6])
    assert_equal(120, p.pool.count, 'Wrong number of tokens for 3 houses')
  end
end
