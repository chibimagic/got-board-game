class TestGameActionConsolidatePower < MiniTest::Test
  def test_consolidate_power
    data = [
      { :area => KingsLanding, :expected_power => 3 },
      { :area => CastleBlack, :expected_power => 2 },
      { :area => TheShiveringSea, :expected_power => 1 }
    ]
    data.each do |datum|
      g = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
      power_before = g.house(HouseStark).count_tokens(PowerToken)
      g.map = Map.create_new([])
      g.map.area(datum[:area]).receive_token!(Footman.create_new(HouseStark))
      g.map.area(datum[:area]).receive_token!(ConsolidatePowerOrder.new(HouseStark))
      4.times { g.game_state.next_step }
      g.execute_consolidate_power_order!(datum[:area])
      power_after = g.house(HouseStark).count_tokens(PowerToken)
      assert_equal(power_before + datum[:expected_power], power_after)
    end
  end
end
