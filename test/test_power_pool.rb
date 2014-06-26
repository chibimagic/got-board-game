class TestPowerPool < Test::Unit::TestCase
  def test_count
    p1 = Player.new('', HouseStark)
    p2 = Player.new('', HouseLannister)
    p3 = Player.new('', HouseBaratheon)
    p4 = Player.new('', HouseGreyjoy)
    p5 = Player.new('', HouseTyrell)
    p6 = Player.new('', HouseMartell)

    p = PowerPool.new([p1, p2, p3])
    assert_equal(60, p.pool.count, 'Wrong number of tokens for 3 players')
    p = PowerPool.new([p1, p2, p3, p4])
    assert_equal(80, p.pool.count, 'Wrong number of tokens for 3 players')
    p = PowerPool.new([p1, p2, p3, p4, p5])
    assert_equal(100, p.pool.count, 'Wrong number of tokens for 3 players')
    p = PowerPool.new([p1, p2, p3, p4, p5, p6])
    assert_equal(120, p.pool.count, 'Wrong number of tokens for 3 players')
  end
end
