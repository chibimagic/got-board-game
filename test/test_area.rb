class TestArea < MiniTest::Test
  def setup
    @m = Map.create_new
  end

  def test_equality
    a1 = CastleBlack.create_new
    a2 = CastleBlack.create_new
    a3 = Karhold.create_new
    assert_equal(a1, a2)
    refute_equal(a1, a3)

    a1.place_token(Footman.new(HouseStark))
    refute_equal(a1, a2)

    a1.remove_token(Footman)
    assert_equal(a1, a2)
  end

  def test_area_something
    @m.areas.each do |area|
      has_strategic_value = area.has_stronghold? || area.has_castle? || area.supply > 0 || area.power > 0
      if area.kind_of?(LandArea)
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
      a = area_class.create_new
      assert_equal(points, a.mustering_points, a.to_s + ' has wrong number of mustering points')
    end
  end

  def test_area_totals
    land_areas = @m.areas.count { |area| area.is_a?(LandArea) }
    sea_areas = @m.areas.count { |area| area.is_a?(SeaArea) }
    port_areas = @m.areas.count { |area| area.is_a?(PortArea) }
    strongholds = @m.areas.count { |area| area.has_stronghold? }
    castles = @m.areas.count { |area| area.has_castle? }
    supply = @m.areas.inject(0) { |sum, area| sum + area.supply }
    power = @m.areas.inject(0) { |sum, area| sum + area.power }
    assert_equal(38, land_areas, 'Map port count incorrect')
    assert_equal(12, sea_areas, 'Map port count incorrect')
    assert_equal(8, port_areas, 'Map port count incorrect')
    assert_equal(10, strongholds, 'Map stronghold count incorrect')
    assert_equal(10, castles, 'Map castle count incorrect')
    assert_equal(24, supply, 'Map supply count incorrect')
    assert_equal(19, power, 'Map power count incorrect')
  end

  def test_port_connection
    ports = @m.areas.find_all { |area| area.is_a?(PortArea) }
    ports.each do |port|
      assert_equal(LandArea, port.land.superclass, port.to_s + ' should be connected to land')
      assert_equal(SeaArea, port.sea.superclass, port.to_s + ' should be connected to the sea')
    end
  end

  def test_port_uniqueness
    expected_port_lands = [Dragonstone, Lannisport, Oldtown, Pyke, StormsEnd, Sunspear, WhiteHarbor, Winterfell]
    expected_port_seas = [BayOfIce, EastSummerSea, IronmansBay, RedwyneStraits, ShipbreakerBay, TheGoldenSound, TheNarrowSea]
    ports = @m.areas.find_all { |area| area.is_a?(PortArea) }
    port_lands = ports.map { |port| port.land }
    port_seas = ports.map { |port| port.sea }
    assert_equal(expected_port_lands.to_set, port_lands.to_set, 'Wrong land areas for port')
    assert_equal(expected_port_seas.to_set, port_seas.to_set, 'Wrong sea areas for port')
    assert_equal(port_lands, port_lands.uniq, 'Multiple ports in a land area')
    refute_equal(port_seas, port_seas.uniq, 'Should be multiple ports on a sea')
  end

  def test_house_control
    area = CastleBlack.create_new
    assert_equal(nil, area.controlling_house, 'Area should be initially uncontrolled')

    area.place_token(Footman.new(HouseStark))
    assert_equal(HouseStark, area.controlling_house, 'Area should be controlled by House Stark')

    area.remove_token(Footman)
    assert_equal(nil, area.controlling_house, 'Area should revert to uncontrolled')

    area.place_token(Footman.new(HouseLannister))
    assert_equal(HouseLannister, area.controlling_house, 'Area should be controlled by House Lannister')
  end

  def test_unit_count
    area = Winterfell.create_new
    assert_equal(0, area.unit_count, 'Area should start with no units')
    area.place_token(Footman.new(HouseStark))
    assert_equal(1, area.unit_count, 'Footman should count has 1 unit')
    area.place_token(Knight.new(HouseStark))
    assert_equal(2, area.unit_count, 'Knight should count as 1 unit')
    area.place_token(GarrisonToken.new(HouseStark))
    assert_equal(2, area.unit_count, 'Garrison token should not count as unit')
    area.place_token(PowerToken.new(HouseStark))
    assert_equal(2, area.unit_count, 'Power token should not count as unit')
    area.place_token(MarchOrder.new(HouseStark))
    assert_equal(2, area.unit_count, 'Orders should not count as unit')
  end

  def test_token_existence
    a = CastleBlack.create_new
    assert_equal(false, a.has_token?(Footman))
    assert_equal(false, a.has_token?(PowerToken))
    assert_equal(false, a.has_token?(MarchOrder))
    assert_equal(false, a.has_token?(GarrisonToken))

    a.place_token(Footman.new(HouseStark))
    assert_equal(true, a.has_token?(Footman))
    a.place_token(PowerToken.new(HouseStark))
    assert_equal(true, a.has_token?(PowerToken))
    a.place_token(MarchOrder.new(HouseStark))
    assert_equal(true, a.has_token?(MarchOrder))
    a.place_token(GarrisonToken.new(HouseStark))
    assert_equal(true, a.has_token?(GarrisonToken))
  end

  def test_place_token
    a = CastleBlack.create_new

    e = assert_raises(RuntimeError) { a.place_token(MarchOrder.new(HouseStark)) }
    assert_equal('House Stark cannot place March Order because Castle Black (0) has no units', e.message)

    a.place_token(Footman.new(HouseStark))
    e = assert_raises(RuntimeError) { a.place_token(MarchOrder.new(HouseLannister)) }
    assert_equal('House Lannister cannot place March Order because Castle Black (1) is controlled by House Stark', e.message)

    a.place_token(MarchOrder.new(HouseStark))
    e = assert_raises(RuntimeError) { a.place_token(MarchOrder.new(HouseStark)) }
    assert_equal('House Stark cannot place March Order because Castle Black (2) already has an order token', e.message)
  end
end
