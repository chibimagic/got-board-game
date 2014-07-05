class TestOrderToken < MiniTest::Test
  def setup
    @t = HouseStark.new.order_tokens
  end

  def test_bonuses
    data = {
      MarchOrder => [-1, 0, 1],
      DefenseOrder => [1, 1, 2],
      SupportOrder => [0, 0, 1],
      RaidOrder => [0, 0, 0],
      ConsolidatePowerOrder => [0, 0, 0]
    }
    data.each do |order_class, expected_bonuses|
      actual_bonuses = @t.find_all { |token| token.is_a?(order_class) }.map { |token| token.bonus }
      assert_equal(expected_bonuses, actual_bonuses, 'Wrong bonuses for ' + order_class.to_s)
    end
  end

  def test_special_count
    assert_equal(5, @t.count { |token| token.special }, 'Wrong number of special order tokens')
    assert_equal(10, @t.count { |token| !token.special }, 'Wrong number of normal order tokens')
  end
end
