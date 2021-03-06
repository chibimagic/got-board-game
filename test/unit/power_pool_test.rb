class PowerPoolTest < MiniTest::Test
  def test_serialize
    original_pool = PowerPool.create_new([HouseStark, HouseLannister, HouseBaratheon])
    stored_pool = original_pool.serialize.to_json
    restored_pool = PowerPool.unserialize(JSON.parse(stored_pool))
    assert_equal(original_pool, restored_pool)
  end

  def test_equality
    p1 = PowerPool.create_new([HouseStark, HouseLannister, HouseBaratheon])
    p2 = PowerPool.create_new([HouseStark, HouseLannister, HouseBaratheon])
    p3 = PowerPool.create_new([HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy])
    assert_equal(p1, p2)

    p1.remove!(HouseStark)
    refute_equal(p1, p2)

    p2.remove!(HouseStark)
    assert_equal(p1, p2)
  end

  def test_count
    h1 = HouseStark
    h2 = HouseLannister
    h3 = HouseBaratheon
    h4 = HouseGreyjoy
    h5 = HouseTyrell
    h6 = HouseMartell

    p = PowerPool.create_new([h1, h2, h3])
    assert_equal(45, p.tokens.count, 'Wrong number of tokens for 3 houses')
    p = PowerPool.create_new([h1, h2, h3, h4])
    assert_equal(60, p.tokens.count, 'Wrong number of tokens for 3 houses')
    p = PowerPool.create_new([h1, h2, h3, h4, h5])
    assert_equal(75, p.tokens.count, 'Wrong number of tokens for 3 houses')
    p = PowerPool.create_new([h1, h2, h3, h4, h5, h6])
    assert_equal(90, p.tokens.count, 'Wrong number of tokens for 3 houses')
  end

  def test_token_removal
    p = PowerPool.create_new([HouseStark, HouseLannister, HouseBaratheon])
    15.times { p.remove!(HouseStark) }
    e = assert_raises(RuntimeError) { p.remove!(HouseStark) }
    assert_equal('Power Pool has no items matching House Stark', e.message)
  end
end
