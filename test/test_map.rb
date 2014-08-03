class TestMap < MiniTest::Test
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

    m1.area(CastleBlack).receive_token!(Footman.create_new(HouseStark))
    refute_equal(m1, m2)

    m1.area(CastleBlack).remove_token!(Footman)
    assert_equal(m1, m2)
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

    @m.area(BayOfIce).receive_token!(Ship.create_new(HouseStark))

    assert_equal(false, @m.connected_via_ship_transport?(HouseStark, BayOfIce, SunsetSea))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, CastleBlack, Winterfell))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, Winterfell, CastleBlack))
    assert_equal(false, @m.connected_via_ship_transport?(HouseStark, CastleBlack, Starfall))
    assert_equal(false, @m.connected_via_ship_transport?(HouseStark, Starfall, CastleBlack))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, CastleBlack, Winterfell))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, Winterfell, CastleBlack))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, CastleBlack, Starfall))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, Starfall, CastleBlack))

    @m.area(SunsetSea).receive_token!(Ship.create_new(HouseStark))
    @m.area(WestSummerSea).receive_token!(Ship.create_new(HouseStark))

    assert_equal(false, @m.connected_via_ship_transport?(HouseStark, BayOfIce, SunsetSea))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, CastleBlack, Winterfell))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, Winterfell, CastleBlack))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, CastleBlack, Starfall))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, Starfall, CastleBlack))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, CastleBlack, Winterfell))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, Winterfell, CastleBlack))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, CastleBlack, Starfall))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, Starfall, CastleBlack))

    @m.area(TheShiveringSea).receive_token!(Ship.create_new(HouseLannister))

    assert_equal(false, @m.connected_via_ship_transport?(HouseStark, BayOfIce, SunsetSea))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, CastleBlack, Winterfell))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, Winterfell, CastleBlack))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, CastleBlack, Starfall))
    assert_equal(true, @m.connected_via_ship_transport?(HouseStark, Starfall, CastleBlack))
    assert_equal(true, @m.connected_via_ship_transport?(HouseLannister, CastleBlack, Winterfell))
    assert_equal(true, @m.connected_via_ship_transport?(HouseLannister, Winterfell, CastleBlack))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, CastleBlack, Starfall))
    assert_equal(false, @m.connected_via_ship_transport?(HouseLannister, Starfall, CastleBlack))

    @m.area(TheNarrowSea).receive_token!(Ship.create_new(HouseLannister))
    @m.area(ShipbreakerBay).receive_token!(Ship.create_new(HouseLannister))
    @m.area(EastSummerSea).receive_token!(Ship.create_new(HouseLannister))

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
    @m.area(CastleBlack).receive_token!(Footman.create_new(h1))
    @m.area(Winterfell).receive_token!(SiegeEngine.create_new(h1))
    @m.area(Winterfell).receive_token!(Knight.create_new(h1))
    @m.area(Winterfell).receive_token!(Footman.create_new(h1))
    @m.area(Karhold).receive_token!(Knight.create_new(h1))
    @m.area(Karhold).receive_token!(Knight.create_new(h1))
    @m.area(Lannisport).receive_token!(Knight.create_new(h2))
    @m.area(Lannisport).receive_token!(Knight.create_new(h2))
    @m.area(StoneySept).receive_token!(Knight.create_new(h2))
    assert_equal([3, 2], @m.armies(HouseStark), 'Army count wrong')
    assert_equal([2], @m.armies(HouseLannister), 'Army count wrong')
  end

  def test_orders
    h = HouseStark
    @m.area(Winterfell).receive_token!(Footman.create_new(h))
    @m.area(Winterfell).receive_token!(WeakMarchOrder.new(h))
    assert_equal({ Winterfell => WeakMarchOrder }, @m.orders)
  end

  def test_orders_in
    assert_equal(true, @m.orders_in?)
    @m.area(CastleBlack).receive_token!(Footman.create_new(HouseStark))
    assert_equal(false, @m.orders_in?)
    @m.area(CastleBlack).receive_token!(MarchOrder.new(HouseStark))
    assert_equal(true, @m.orders_in?)
  end
end
