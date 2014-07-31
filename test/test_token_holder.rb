class TestTokenHolder < MiniTest::Test
  def test_remove_units
    h = HouseStark.create_new
    10.times { h.remove_token!(Footman) }
    e = assert_raises(RuntimeError) { h.remove_token!(Footman) }
    assert_equal('House Stark (no name) has no tokens matching Footman', e.message)
  end

  class TestClass
    include TokenHolder
  end

  def test_implement_get_tokens
    o = TestClass.new
    e = assert_raises(RuntimeError) { o.count_tokens(true) }
    assert_equal('To use TokenHolder, implement get_tokens', e.message)
  end
end
