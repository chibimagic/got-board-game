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

  def test_area_mustering_points
    expected_points = {
      BayOfIce => 0,
      BlackwaterBay => 0,
      EastSummerSea => 0,
      IronmansBay => 0,
      RedwyneStraits => 0,
      SeaOfDorne => 0,
      ShipbreakerBay => 0,
      SunsetSea => 0,
      TheGoldenSound => 0,
      TheNarrowSea => 0,
      TheShiveringSea => 0,
      WestSummerSea => 0,
      Blackwater => 0,
      CastleBlack => 0,
      CrackclawPoint => 1,
      DornishMarches => 0,
      Dragonstone => 2,
      FlintsFinger => 1,
      GreywaterWatch => 0,
      Harrenhal => 1,
      Highgarden => 2,
      Karhold => 0,
      KingsLanding => 2,
      Kingswood => 0,
      Lannisport => 2,
      MoatCalin => 1,
      Oldtown => 2,
      PrincesPass => 0,
      Pyke => 2,
      Riverrun => 2,
      SaltShore => 0,
      Seagard => 2,
      SearoadMarches => 0,
      Starfall => 1,
      StoneySept => 0,
      StormsEnd => 1,
      Sunspear => 2,
      TheArbor => 0,
      TheBoneway => 0,
      TheEyrie => 1,
      TheFingers => 0,
      TheMountainsOfTheMoon => 0,
      TheReach => 1,
      TheStoneyShore => 0,
      TheTwins => 0,
      ThreeTowers => 0,
      WhiteHarbor => 1,
      WidowsWatch => 0,
      Winterfell => 2,
      Yronwood => 1
    }
    expected_points.each do |area_class, points|
      a = area_class.new
      assert_equal(points, a.mustering_points, a.to_s + ' has wrong number of mustering points')
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
    area = CastleBlack.new
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

  def test_unit_count
    h = HouseStark.new

    area = Winterfell.new
    assert_equal(0, area.unit_count, 'Area should start with no units')
    area.tokens.push(Footman.new(h))
    assert_equal(1, area.unit_count, 'Footman should count has 1 unit')
    area.tokens.push(Knight.new(h))
    assert_equal(2, area.unit_count, 'Knight should count as 1 unit')
    area.tokens.push(GarrisonToken.new(h))
    assert_equal(2, area.unit_count, 'Garrison token should not count as unit')
    area.tokens.push(PowerToken.new(h))
    assert_equal(2, area.unit_count, 'Power token should not count as unit')
    area.tokens.push(MarchOrder.new(h, false, 0))
    assert_equal(2, area.unit_count, 'Orders should not count as unit')
  end
end
