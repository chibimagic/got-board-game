class TestToken < MiniTest::Test
  def test_initialize_house_token
    refute_raises { Footman.new(HouseStark) }
    e = assert_raises(RuntimeError) { Footman.new(HouseStark.create_new) }
    assert_equal('Invalid house class', e.message)
    e = assert_raises(RuntimeError) { Footman.new(House) }
    assert_equal('Invalid house class', e.message)
    e = assert_raises(RuntimeError) { Footman.new(String) }
    assert_equal('Invalid house class', e.message)
  end
end
