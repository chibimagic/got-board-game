class UtilityTest < MiniTest::Test
  def test_singular_plural
    assert_equal('tokens', Utility.singular_plural(0, 'token', 'tokens'))
    assert_equal('token', Utility.singular_plural(1, 'token', 'tokens'))
    assert_equal('tokens', Utility.singular_plural(2, 'token', 'tokens'))
  end

  def test_valid_json
    assert_equal(false, Utility.valid_json?(''))
    assert_equal(false, Utility.valid_json?('this is a non-json string'))
    assert_equal(true, Utility.valid_json?('{}'))
    assert_equal(true, Utility.valid_json?('{"a":"b"}'))
    assert_equal(false, Utility.valid_json?("{'a':'b'}"))
  end
end
