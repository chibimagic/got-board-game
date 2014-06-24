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
    castle_black_lands = [Winterfell, Karhold].to_set
    castle_black_seas = [BayOfIce, TheShiveringSea].to_set
    assert_equal(castle_black_lands + castle_black_seas, @m.connected_areas(CastleBlack), 'Castle Black has wrong areas connected')
    assert_equal(castle_black_lands, @m.connected_lands(CastleBlack), 'Castle Black has wrong areas connected')
    assert_equal(castle_black_seas, @m.connected_seas(CastleBlack), 'Castle Black has wrong areas connected')
  end
end
