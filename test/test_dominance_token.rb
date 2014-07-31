class TestDominanceToken < MiniTest::Test
  def test_usable_token
    token_classes = [ValyrianSteelBladeToken, MessengerRavenToken]
    token_classes.each do |token_class|
      t = token_class.create_new
      assert_equal(false, t.used)
      t.use!
      assert_equal(true, t.used)
      t.reset
      assert_equal(false, t.used)
    end
  end

  def test_usable_token_reuse
    token_classes = [ValyrianSteelBladeToken, MessengerRavenToken]
    token_classes.each do |token_class|
      e = assert_raises(RuntimeError) {
        t = token_class.create_new
        t.use!
        t.use!
      }
      assert_match(/ has already been used$/, e.message)
    end
  end
end
