class TestToken < MiniTest::Test
  def test_initialize_house_token
    refute_raises { Footman.new(HouseStark) }
    assert_raises(RuntimeError) { Footman.new(HouseStark.new) }
    assert_raises(RuntimeError) { Footman.new(House) }
    assert_raises(RuntimeError) { Footman.new(String) }
  end
end
