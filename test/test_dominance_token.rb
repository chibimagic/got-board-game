class TestDominanceToken < Test::Unit::TestCase
  def test_usable_token
    token_classes = [ValyrianSteelBladeToken, MessengerRavenToken]
    token_classes.each do |token_class|
      t = token_class.new
      assert_equal(false, t.used)
      t.use
      assert_equal(true, t.used)
      t.reset
      assert_equal(false, t.used)
    end
  end

  def test_usable_token_reuse
    token_classes = [ValyrianSteelBladeToken, MessengerRavenToken]
    token_classes.each do |token_class|
      assert_raise(RuntimeError) {
        t = token_class.new
        t.use
        t.use
      }
    end
  end
end
