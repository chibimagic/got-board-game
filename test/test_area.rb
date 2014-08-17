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

    a1.receive!(Footman.create_new(HouseStark))
    refute_equal(a1, a2)

    a1.remove!(Footman)
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
      land_classes = @m.connected_land_classes(port.class)
      sea_classes = @m.connected_sea_classes(port.class)
      assert_equal(1, land_classes.length, port.to_s + ' should be connected to one land area')
      assert_equal(1, sea_classes.length, port.to_s + ' should be connected to one sea area')
      assert_equal(LandArea, land_classes.first.superclass, port.to_s + ' should be connected to land')
      assert_equal(SeaArea, sea_classes.first.superclass, port.to_s + ' should be connected to the sea')
    end
  end

  def test_port_uniqueness
    expected_port_lands = [Dragonstone, Lannisport, Oldtown, Pyke, StormsEnd, Sunspear, WhiteHarbor, Winterfell]
    expected_port_seas = [BayOfIce, EastSummerSea, IronmansBay, RedwyneStraits, ShipbreakerBay, TheGoldenSound, TheNarrowSea]
    ports = @m.areas.find_all { |area| area.is_a?(PortArea) }
    port_lands = ports.map { |port| @m.connected_land_classes(port.class) }.flatten
    port_seas = ports.map { |port| @m.connected_sea_classes(port.class) }.flatten
    assert_equal(expected_port_lands.to_set, port_lands.to_set, 'Wrong land areas for port')
    assert_equal(expected_port_seas.to_set, port_seas.to_set, 'Wrong sea areas for port')
    assert_equal(port_lands, port_lands.uniq, 'Multiple ports in a land area')
    refute_equal(port_seas, port_seas.uniq, 'Should be multiple ports on a sea')
  end

  def test_house_control
    area = CastleBlack.create_new
    assert_equal(nil, area.controlling_house_class, 'Area should be initially uncontrolled')

    area.receive!(Footman.create_new(HouseStark))
    assert_equal(HouseStark, area.controlling_house_class, 'Area should be controlled by House Stark')

    area.remove!(Footman)
    assert_equal(nil, area.controlling_house_class, 'Area should revert to uncontrolled')

    area.receive!(Footman.create_new(HouseLannister))
    assert_equal(HouseLannister, area.controlling_house_class, 'Area should be controlled by House Lannister')
  end

  def test_unit_count
    area = Winterfell.create_new
    assert_equal(0, area.count(Unit), 'Area should start with no units')
    area.receive!(Footman.create_new(HouseStark))
    assert_equal(1, area.count(Unit), 'Footman should count has 1 unit')
    area.receive!(Knight.create_new(HouseStark))
    assert_equal(2, area.count(Unit), 'Knight should count as 1 unit')
    area.receive!(GarrisonToken.new(HouseStark))
    assert_equal(2, area.count(Unit), 'Garrison token should not count as unit')
    area.receive!(PowerToken.new(HouseStark))
    assert_equal(2, area.count(Unit), 'Power token should not count as unit')
    area.receive!(MarchOrder.new(HouseStark))
    assert_equal(2, area.count(Unit), 'Orders should not count as unit')
  end

  def test_token_existence
    a = CastleBlack.create_new
    assert_equal(false, a.has?(Footman))
    assert_equal(false, a.has?(PowerToken))
    assert_equal(false, a.has?(MarchOrder))
    assert_equal(false, a.has?(GarrisonToken))

    a.receive!(Footman.create_new(HouseStark))
    assert_equal(true, a.has?(Footman))
    a.receive!(PowerToken.new(HouseStark))
    assert_equal(true, a.has?(PowerToken))
    a.receive!(MarchOrder.new(HouseStark))
    assert_equal(true, a.has?(MarchOrder))
    a.receive!(GarrisonToken.new(HouseStark))
    assert_equal(true, a.has?(GarrisonToken))
  end

  def test_receive_token_override
    a = CastleBlack.create_new
    e = assert_raises(RuntimeError) { a.receive(MarchOrder.new(HouseStark)) }
    assert_equal('Call :receive! instead', e.message)
  end

  def test_receive_token_area
    a = CastleBlack.create_new

    e = assert_raises(RuntimeError) { a.receive!(MarchOrder.new(HouseStark)) }
    assert_equal('Cannot place March Order (House Stark) because Castle Black (0) has no units', e.message)

    a.receive!(Footman.create_new(HouseStark))
    e = assert_raises(RuntimeError) { a.receive!(MarchOrder.new(HouseLannister)) }
    assert_equal('Cannot place March Order (House Lannister) because Castle Black (1) is controlled by House Stark', e.message)

    a.receive!(MarchOrder.new(HouseStark))
    e = assert_raises(RuntimeError) { a.receive!(MarchOrder.new(HouseStark)) }
    assert_equal('Cannot place March Order (House Stark) because Castle Black (2) already has an order token', e.message)
  end

  def test_receive_token_area_type
    l = Winterfell.create_new
    s = BayOfIce.create_new
    p = WinterfellPortToBayOfIce.create_new

    refute_raises { l.receive!(Footman.create_new(HouseStark)) }
    refute_raises { l.receive!(Knight.create_new(HouseStark)) }
    refute_raises { l.receive!(SiegeEngine.create_new(HouseStark)) }
    e = assert_raises(RuntimeError) { l.receive!(Ship.create_new(HouseStark)) }
    assert_equal('Cannot place Ship (House Stark) because Winterfell (3) is a land area', e.message)

    e = assert_raises(RuntimeError) { s.receive!(Footman.create_new(HouseStark)) }
    assert_equal('Cannot place Footman (House Stark) because Bay of Ice (0) is a sea area', e.message)
    e = assert_raises(RuntimeError) { s.receive!(Knight.create_new(HouseStark)) }
    assert_equal('Cannot place Knight (House Stark) because Bay of Ice (0) is a sea area', e.message)
    e = assert_raises(RuntimeError) { s.receive!(SiegeEngine.create_new(HouseStark)) }
    assert_equal('Cannot place Siege Engine (House Stark) because Bay of Ice (0) is a sea area', e.message)
    refute_raises { s.receive!(Ship.create_new(HouseStark)) }

    e = assert_raises(RuntimeError) { p.receive!(Footman.create_new(HouseStark)) }
    assert_equal('Cannot place Footman (House Stark) because Winterfell Port (Bay of Ice) (0) is a port area', e.message)
    e = assert_raises(RuntimeError) { p.receive!(Knight.create_new(HouseStark)) }
    assert_equal('Cannot place Knight (House Stark) because Winterfell Port (Bay of Ice) (0) is a port area', e.message)
    e = assert_raises(RuntimeError) { p.receive!(SiegeEngine.create_new(HouseStark)) }
    assert_equal('Cannot place Siege Engine (House Stark) because Winterfell Port (Bay of Ice) (0) is a port area', e.message)
    refute_raises { s.receive!(Ship.create_new(HouseStark)) }
  end

  def test_port_three_ships_max
    p = WinterfellPortToBayOfIce.create_new
    refute_raises { p.receive!(Ship.create_new(HouseStark)) }
    refute_raises { p.receive!(Ship.create_new(HouseStark)) }
    refute_raises { p.receive!(Ship.create_new(HouseStark)) }
    e = assert_raises(RuntimeError) { p.receive!(Ship.create_new(HouseStark)) }
    assert_equal('Cannot place more than 3 Ships in a port area', e.message)
  end
end
