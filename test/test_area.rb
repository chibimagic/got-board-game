class TestArea < Test::Unit::TestCase
  def setup
    @m = Map.new
  end

  def test_area_something
    @m.areas.each do |area|
      has_strategic_value = area.has_stronghold? || area.has_castle? || area.supply > 0 || area.power > 0
      if area.kind_of? LandArea
        assert_equal(true, has_strategic_value, area.to_s + ' should have strategic value')
      else
        assert_equal(false, has_strategic_value, area.to_s + ' should not have strategic value')
      end
    end
  end

  def test_area_stronghold_or_castle
    @m.areas.each do |area|
      assert_equal(false, area.has_stronghold? && area.has_castle?, area.to_s + ' should not have both a stronghold and a castle')
    end
  end

  def test_area_totals
    strongholds = @m.areas.count { |area| area.has_stronghold? }
    castles = @m.areas.count { |area| area.has_castle? }
    supply = @m.areas.inject(0) { |sum, area| sum + area.supply }
    power = @m.areas.inject(0) { |sum, area| sum + area.power }
    ports = @m.areas.count { |area| area.has_port? }
    assert_equal(10, strongholds, 'Map stronghold count incorrect')
    assert_equal(10, castles, 'Map castle count incorrect')
    assert_equal(24, supply, 'Map supply count incorrect')
    assert_equal(19, power, 'Map power count incorrect')
    assert_equal(8, ports, 'Map port count incorrect')
  end

  def test_area_ports
    @m.areas.each do |area|
      if area.has_port?
        assert_not_equal(nil, area.port_to, area.to_s + ' has an unconnected port')
        assert_equal(SeaArea, area.port_to.superclass, area.to_s + ' has a port that doesn\'t connect to a sea area')
      end
    end
  end

  def test_house_control
    area = @m.area(CastleBlack)
    stark_unit = Footman.new(HouseStark.new)
    lannister_unit = Footman.new(HouseLannister.new)
    assert_equal(nil, area.controlling_house, 'Area should be initially uncontrolled')

    area.tokens.push(stark_unit)
    assert_equal(HouseStark, area.controlling_house, 'Area should be controlled by House Stark')

    area.tokens.delete(stark_unit)
    assert_equal(nil, area.controlling_house, 'Area should revert to uncontrolled')

    area.tokens.push(lannister_unit)
    assert_equal(HouseLannister, area.controlling_house, 'Area should be controlled by House Lannister')
  end
end
