class TestItemHolder < MiniTest::Test
  def test_remove_units
    h = HouseStark.create_new
    10.times { h.remove!(Footman) }
    e = assert_raises(RuntimeError) { h.remove!(Footman) }
    assert_equal('House Stark has no items matching Footman', e.message)
  end

  class TestClass
    include ItemHolder
  end

  def test_implement_get_tokens
    o = TestClass.new
    e = assert_raises(RuntimeError) { o.count(true) }
    assert_equal('To use ItemHolder, implement get_all', e.message)
  end
end
