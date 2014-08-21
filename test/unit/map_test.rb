class MapTest < MiniTest::Test
  def setup
    @m = Map.create_new
  end

  def test_serialize
    original_map = Map.create_new
    stored_map = original_map.serialize.to_json
    restored_map = Map.unserialize(JSON.parse(stored_map))
    assert_equal(original_map, restored_map)
  end

  def test_equality
    m1 = Map.create_new
    m2 = Map.create_new
    assert_equal(m1, m2)

    m1.area(CastleBlack).receive!(Footman.create_new(HouseStark))
    refute_equal(m1, m2)

    m1.area(CastleBlack).remove!(Footman)
    assert_equal(m1, m2)
  end

  def test_initialize
    houses = [HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new, HouseGreyjoy.create_new, HouseTyrell.create_new, HouseMartell.create_new]
    m = Map.create_new(houses)
    expected_supply_track = {
      0 => [],
      1 => [HouseStark],
      2 => [HouseLannister, HouseBaratheon, HouseGreyjoy, HouseTyrell, HouseMartell],
      3 => [],
      4 => [],
      5 => [],
      6 => [],
    }
    assert_equal(expected_supply_track, m.supply_track)
  end

  def test_initialize_invalid
    data = [
      [
        [0 => []],
        [1 => []],
        [2 => []],
        [3 => []],
        [4 => []],
        [5 => []],
        [6 => []],
      ],
      {
        '0' => [],
        '1' => [],
        '2' => [],
        '3' => [],
        '4' => [],
        '5' => [],
        '6' => [],
      },
      {
        6 => [],
        5 => [],
        4 => [],
        3 => [],
        2 => [],
        1 => [],
        0 => [],
      },
      {
        0 => {},
        1 => {},
        2 => {},
        3 => {},
        4 => {},
        5 => {},
        6 => {},
      },
      {
        0 => [],
        1 => [HouseStark.create_new],
        2 => [HouseLannister.create_new],
        3 => [HouseBaratheon.create_new],
        4 => [HouseGreyjoy.create_new],
        5 => [HouseTyrell.create_new],
        6 => [HouseMartell.create_new],
      }
    ]
    data.each do |datum|
      begin
        Map.new([], datum)
        p datum
      rescue
      end
      e = assert_raises(RuntimeError) { Map.new([], datum) }
      assert_equal('Invalid supply track', e.message)
    end
  end

  def test_connection_count_area
    @m.areas.each do |area|
      assert_equal(area.connection_count, @m.connected_area_classes(area.class).count, area.to_s + ' has wrong number of connections')
    end
  end

  def test_connection_count_total
    land_to_land = @m.connections.count { |connection| connection.count { |area| area < LandArea } == connection.count }
    land_to_sea = @m.connections.count { |connection| connection.count { |area| area < SeaArea } == connection.count { |area| area < LandArea } }
    sea_to_sea = @m.connections.count { |connection| connection.count { |area| area < SeaArea } == connection.count }
    assert_equal(63, land_to_land, 'Wrong number of land-to-land connections')
    assert_equal(52, land_to_sea, 'Wrong number of land-to-sea connections')
    assert_equal(12, sea_to_sea, 'Wrong number of sea-to-sea connections')
  end

  def test_connected
    assert_equal(true, @m.connected?(CastleBlack, Winterfell), 'Castle Black and Winterfell should be connected')
    assert_equal(true, @m.connected?(Winterfell, CastleBlack), 'Castle Black and Winterfell should be connected even when reversed')
    assert_equal(false, @m.connected?(CastleBlack, EastSummerSea), 'CastleBlack and East Summer Sea should not be connected')
    assert_equal(false, @m.connected?(EastSummerSea, CastleBlack), 'CastleBlack and East Summer Sea should not be connected even when reversed')
  end

  def test_connected_via_ship_transport
    assert_equal(false, @m.connected_via_ship_transport?(HouseStark, BayOfIce, SunsetSea))
    assert_equal(false, @m.connected_via_ship_transport?(HouseStark, CastleBlack, Winterfell))
    assert_equal(false, @m.connected_via_ship_transport?(HouseStark, Winterfell, CastleBlack))
    assert_equal(false, @m.connected_via_ship_transport?(HouseStark, CastleBlack, Starfall))
    assert_equal(false, @m.connected_via_ship_transport?(HouseStark, Starfall, CastleBlack))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, CastleBlack, Winterfell))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, Winterfell, CastleBlack))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, CastleBlack, Starfall))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, Starfall, CastleBlack))

    @m.area(BayOfIce).receive!(Ship.create_new(HouseStark))

    assert_equal(false, @m.connected_via_ship_transport?(HouseStark, BayOfIce, SunsetSea))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, CastleBlack, Winterfell))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, Winterfell, CastleBlack))
    assert_equal(false, @m.connected_via_ship_transport?(HouseStark, CastleBlack, Starfall))
    assert_equal(false, @m.connected_via_ship_transport?(HouseStark, Starfall, CastleBlack))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, CastleBlack, Winterfell))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, Winterfell, CastleBlack))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, CastleBlack, Starfall))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, Starfall, CastleBlack))

    @m.area(SunsetSea).receive!(Ship.create_new(HouseStark))
    @m.area(WestSummerSea).receive!(Ship.create_new(HouseStark))

    assert_equal(false, @m.connected_via_ship_transport?(HouseStark, BayOfIce, SunsetSea))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, CastleBlack, Winterfell))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, Winterfell, CastleBlack))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, CastleBlack, Starfall))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, Starfall, CastleBlack))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, CastleBlack, Winterfell))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, Winterfell, CastleBlack))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, CastleBlack, Starfall))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, Starfall, CastleBlack))

    @m.area(TheShiveringSea).receive!(Ship.create_new(HouseLannister))

    assert_equal(false, @m.connected_via_ship_transport?(HouseStark, BayOfIce, SunsetSea))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, CastleBlack, Winterfell))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, Winterfell, CastleBlack))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, CastleBlack, Starfall))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, Starfall, CastleBlack))
    assert_equal(true, @m.connected_via_ship_transport?(HouseLannister, CastleBlack, Winterfell))
    assert_equal(true, @m.connected_via_ship_transport?(HouseLannister, Winterfell, CastleBlack))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, CastleBlack, Starfall))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, Starfall, CastleBlack))

    @m.area(TheNarrowSea).receive!(Ship.create_new(HouseLannister))
    @m.area(ShipbreakerBay).receive!(Ship.create_new(HouseLannister))
    @m.area(EastSummerSea).receive!(Ship.create_new(HouseLannister))

    assert_equal(false, @m.connected_via_ship_transport?(HouseStark, BayOfIce, SunsetSea))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, CastleBlack, Winterfell))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, Winterfell, CastleBlack))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, CastleBlack, Starfall))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, Starfall, CastleBlack))
    assert_equal(true, @m.connected_via_ship_transport?(HouseLannister, CastleBlack, Winterfell))
    assert_equal(true, @m.connected_via_ship_transport?(HouseLannister, Winterfell, CastleBlack))
    assert_equal(true, @m.connected_via_ship_transport?(HouseLannister, CastleBlack, Starfall))
    assert_equal(true, @m.connected_via_ship_transport?(HouseLannister, Starfall, CastleBlack))
  end

  def test_connected_areas
    castle_black_land_classes = [Winterfell, Karhold]
    castle_black_sea_classes = [BayOfIce, TheShiveringSea]
    assert_equal(castle_black_land_classes.to_set + castle_black_sea_classes.to_set, @m.connected_area_classes(CastleBlack).to_set, 'Castle Black has wrong areas connected')
    assert_equal(castle_black_land_classes.to_set, @m.connected_land_classes(CastleBlack).to_set, 'Castle Black has wrong areas connected')
    assert_equal(castle_black_sea_classes.to_set, @m.connected_sea_classes(CastleBlack).to_set, 'Castle Black has wrong areas connected')
  end

  def test_army_count
    h1 = HouseStark
    h2 = HouseLannister
    @m.area(CastleBlack).receive!(Footman.create_new(h1))
    @m.area(Winterfell).receive!(SiegeEngine.create_new(h1))
    @m.area(Winterfell).receive!(Knight.create_new(h1))
    @m.area(Winterfell).receive!(Footman.create_new(h1))
    @m.area(Karhold).receive!(Knight.create_new(h1))
    @m.area(Karhold).receive!(Knight.create_new(h1))
    @m.area(Lannisport).receive!(Knight.create_new(h2))
    @m.area(Lannisport).receive!(Knight.create_new(h2))
    @m.area(StoneySept).receive!(Knight.create_new(h2))
    assert_equal([3, 2], @m.armies(HouseStark), 'Army count wrong')
    assert_equal([2], @m.armies(HouseLannister), 'Army count wrong')
  end

  def test_has_order
    data = [
      WeakMarchOrder,
      MarchOrder,
      SpecialMarchOrder,
      DefenseOrder,
      SpecialDefenseOrder,
      SupportOrder,
      SpecialSupportOrder,
      RaidOrder,
      SpecialRaidOrder,
      ConsolidatePowerOrder,
      SpecialConsolidatePowerOrder
    ]
    data.each do |datum|
      m = Map.create_new
      m.area(CastleBlack).receive!(Footman.create_new(HouseStark))
      m.area(CastleBlack).receive!(datum.new(HouseStark))
      assert_equal(true, m.has_order?(datum, HouseStark))
      assert_equal(true, m.has_order?(datum.superclass, HouseStark))
      assert_equal(false, m.has_order?(datum, HouseLannister))
      assert_equal(false, m.has_order?(datum.superclass, HouseLannister))
    end
  end

  def test_level_houses
    m = Map.new([], {
      0 => [],
      1 => [HouseStark],
      2 => [HouseLannister],
      3 => [HouseBaratheon],
      4 => [HouseGreyjoy],
      5 => [HouseTyrell],
      6 => [HouseMartell],
    })

    assert_equal(1, m.supply_level(HouseStark))
    assert_equal(2, m.supply_level(HouseLannister))
    assert_equal(3, m.supply_level(HouseBaratheon))
    assert_equal(4, m.supply_level(HouseGreyjoy))
    assert_equal(5, m.supply_level(HouseTyrell))
    assert_equal(6, m.supply_level(HouseMartell))

    assert_equal([HouseStark], m.houses(1))
    assert_equal([HouseLannister], m.houses(2))
    assert_equal([HouseBaratheon], m.houses(3))
    assert_equal([HouseGreyjoy], m.houses(4))
    assert_equal([HouseTyrell], m.houses(5))
    assert_equal([HouseMartell], m.houses(6))
  end

  def test_set_level
    m = Map.new([], {
      0 => [],
      1 => [HouseStark],
      2 => [HouseLannister],
      3 => [HouseBaratheon],
      4 => [HouseGreyjoy],
      5 => [HouseTyrell],
      6 => [HouseMartell],
    })

    m.set_level(HouseStark, 6)
    m.set_level(HouseLannister, 5)
    m.set_level(HouseBaratheon, 5)
    m.set_level(HouseGreyjoy, 0)
    m.set_level(HouseGreyjoy, 4)
    m.set_level(HouseTyrell, 0)

    expected_track = {
      0 => [HouseTyrell],
      1 => [],
      2 => [],
      3 => [],
      4 => [HouseGreyjoy],
      5 => [HouseLannister, HouseBaratheon],
      6 => [HouseMartell, HouseStark],
    }

    assert_equal(expected_track, m.supply_track)
  end

  def test_armies_allowed
    m = Map.new([], {
      0 => [],
      1 => [HouseMartell],
      2 => [HouseTyrell],
      3 => [HouseGreyjoy],
      4 => [HouseBaratheon],
      5 => [HouseLannister],
      6 => [HouseStark],
    })

    assert_equal([3, 2], m.armies_allowed(HouseMartell))
    assert_equal([3, 2, 2], m.armies_allowed(HouseTyrell))
    assert_equal([3, 2, 2, 2], m.armies_allowed(HouseGreyjoy))
    assert_equal([3, 3, 2, 2], m.armies_allowed(HouseBaratheon))
    assert_equal([4, 3, 2, 2], m.armies_allowed(HouseLannister))
    assert_equal([4, 3, 2, 2, 2], m.armies_allowed(HouseStark))
  end

  def test_supply_limits
    data = [
      # 0 => [2, 2],
      # 1 => [3, 2],
      # 2 => [3, 2, 2],
      # 3 => [3, 2, 2, 2],
      # 4 => [3, 3, 2, 2],
      # 5 => [4, 3, 2, 2],
      # 6 => [4, 3, 2, 2, 2]
      { :armies => [], :supply_required => 0 },
      { :armies => [2], :supply_required => 0 },
      { :armies => [2, 2], :supply_required => 0 },
      { :armies => [3, 2], :supply_required => 1 },
      { :armies => [2, 2, 2], :supply_required => 2 },
      { :armies => [2, 2, 2, 2], :supply_required => 3 },
      { :armies => [3, 3], :supply_required => 4 },
      { :armies => [4], :supply_required => 5 },
      { :armies => [2, 2, 2, 2, 2], :supply_required => 6 },
      { :armies => [5], :supply_required => nil },
      { :armies => [3, 3, 3], :supply_required => nil },
      { :armies => [2, 2, 2, 2, 2, 2], :supply_required => nil },
    ]
    areas = [CastleBlack, Winterfell, Karhold, TheStoneyShore, WhiteHarbor, WidowsWatch]
    data.each do |datum|
      m = Map.create_new
      datum[:armies].each_with_index do |army_size, index|
        army_size.times { m.area(areas[index]).receive!(Footman.create_new(HouseStark)) }
      end
      (0..6).each do |supply_level|
        m.set_level(HouseStark, supply_level)
        should_work = datum[:supply_required].is_a?(Integer) && supply_level >= datum[:supply_required]
        assert_equal(should_work, m.conforms_to_supply_limits?(HouseStark))
      end
    end
  end
end
