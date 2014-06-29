class TestMap < Test::Unit::TestCase
  def setup
    @m = Map.new
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
    h1 = HouseStark.new
    h2 = HouseLannister.new
    @m.place_token(CastleBlack, Footman.new(h1))
    @m.place_token(Winterfell, SiegeEngine.new(h1))
    @m.place_token(Winterfell, Knight.new(h1))
    @m.place_token(Winterfell, Footman.new(h1))
    @m.place_token(Karhold, Knight.new(h1))
    @m.place_token(Karhold, Knight.new(h1))
    @m.place_token(Lannisport, Knight.new(h2))
    @m.place_token(Lannisport, Knight.new(h2))
    @m.place_token(StoneySept, Knight.new(h2))
    assert_equal([3, 2], @m.armies(HouseStark), 'Army count wrong')
    assert_equal([2], @m.armies(HouseLannister), 'Army count wrong')
  end

  def test_orders_in
    h = HouseStark.new

    assert_equal(true, @m.orders_in?)
    @m.place_token(CastleBlack, Footman.new(h))
    assert_equal(false, @m.orders_in?)
    @m.place_token(CastleBlack, MarchOrder.new(h))
    assert_equal(true, @m.orders_in?)
  end
end
