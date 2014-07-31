class TestTokenHolder < MiniTest::Test
  def test_remove_units
    h = HouseStark.create_new
    10.times { h.remove_token!(Footman) }
    e = assert_raises(RuntimeError) { h.remove_token!(Footman) }
    assert_equal('House Stark (no name) has no tokens matching Footman', e.message)
  end
end
