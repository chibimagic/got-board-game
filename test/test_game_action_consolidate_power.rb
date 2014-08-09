class TestGameActionConsolidatePower < MiniTest::Test
  def test_consolidate_power
    data = [
      { :area_class => KingsLanding, :expected_power => 3 },
      { :area_class => CastleBlack, :expected_power => 2 },
      { :area_class => TheShiveringSea, :expected_power => 1 },
      { :area_class => WinterfellPortToBayOfIce, :expected_power => 1 }
    ]
    data.each do |datum|
      g = Game.create_new([HouseStark, HouseLannister, HouseBaratheon])
      power_before = g.house(HouseStark).count_tokens(PowerToken)
      g.map = Map.create_new([])
      token_class = datum[:area_class] < LandArea ? Footman : Ship
      g.map.area(datum[:area_class]).receive_token!(token_class.create_new(HouseStark))
      g.map.area(datum[:area_class]).receive_token!(ConsolidatePowerOrder.new(HouseStark))
      g.game_period = :resolve_consolidate_power_orders
      g.execute_consolidate_power_order!(datum[:area_class])
      power_after = g.house(HouseStark).count_tokens(PowerToken)
      assert_equal(power_before + datum[:expected_power], power_after)
    end
  end

  def test_consolidate_power_in_port_with_adjacent_enemy_ships
    g = Game.create_new([HouseStark, HouseLannister, HouseBaratheon])
    power_before = g.house(HouseStark).count_tokens(PowerToken)
    g.map = Map.create_new
    g.map.area(WinterfellPortToBayOfIce).receive_token!(Ship.create_new(HouseStark))
    g.map.area(WinterfellPortToBayOfIce).receive_token!(ConsolidatePowerOrder.new(HouseStark))
    g.map.area(BayOfIce).receive_token!(Ship.create_new(HouseLannister))
    g.game_period = :resolve_consolidate_power_orders
    g.execute_consolidate_power_order!(WinterfellPortToBayOfIce)
    power_after = g.house(HouseStark).count_tokens(PowerToken)
    assert_equal(power_before, power_after)
  end
end
