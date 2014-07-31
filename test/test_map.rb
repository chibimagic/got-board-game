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

    m1.area(CastleBlack).receive_token!(Footman.new(HouseStark))
    refute_equal(m1, m2)

    m1.area(CastleBlack).remove_token!(Footman)
    assert_equal(m1, m2)
  end

  def test_connection_count_area
    @m.areas.each do |area|
      assert_equal(area.connection_count, @m.connected_areas(area.class).count, area.to_s + ' has wrong number of connections')
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

  def test_connected_areas
    castle_black_lands = [Winterfell, Karhold]
    castle_black_seas = [BayOfIce, TheShiveringSea]
    assert_equal(castle_black_lands.to_set + castle_black_seas.to_set, @m.connected_areas(CastleBlack).to_set, 'Castle Black has wrong areas connected')
    assert_equal(castle_black_lands.to_set, @m.connected_lands(CastleBlack).to_set, 'Castle Black has wrong areas connected')
    assert_equal(castle_black_seas.to_set, @m.connected_seas(CastleBlack).to_set, 'Castle Black has wrong areas connected')
  end

  def test_army_count
    h1 = HouseStark
    h2 = HouseLannister
    @m.area(CastleBlack).receive_token!(Footman.new(h1))
    @m.area(Winterfell).receive_token!(SiegeEngine.new(h1))
    @m.area(Winterfell).receive_token!(Knight.new(h1))
    @m.area(Winterfell).receive_token!(Footman.new(h1))
    @m.area(Karhold).receive_token!(Knight.new(h1))
    @m.area(Karhold).receive_token!(Knight.new(h1))
    @m.area(Lannisport).receive_token!(Knight.new(h2))
    @m.area(Lannisport).receive_token!(Knight.new(h2))
    @m.area(StoneySept).receive_token!(Knight.new(h2))
    assert_equal([3, 2], @m.armies(HouseStark), 'Army count wrong')
    assert_equal([2], @m.armies(HouseLannister), 'Army count wrong')
  end

  def test_orders
    h = HouseStark
    @m.area(Winterfell).receive_token!(Footman.new(h))
    @m.area(Winterfell).receive_token!(WeakMarchOrder.new(h))
    assert_equal({ Winterfell => WeakMarchOrder }, @m.orders)
  end

  def test_orders_in
    assert_equal(true, @m.orders_in?)
    @m.area(CastleBlack).receive_token!(Footman.new(HouseStark))
    assert_equal(false, @m.orders_in?)
    @m.area(CastleBlack).receive_token!(MarchOrder.new(HouseStark))
    assert_equal(true, @m.orders_in?)
  end
end
