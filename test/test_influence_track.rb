class TestInfluenceTrack < MiniTest::Test
  def test_initialize
    data = [
      # Default track position for full board
      {
        :houses => [HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy, HouseTyrell, HouseMartell],
        :iron_throne_track => [HouseBaratheon, HouseLannister, HouseStark, HouseMartell, HouseGreyjoy, HouseTyrell],
        :fiefdoms_track => [HouseGreyjoy, HouseTyrell, HouseMartell, HouseStark, HouseBaratheon, HouseLannister],
        :kings_court_track => [HouseLannister, HouseStark, HouseMartell, HouseBaratheon, HouseTyrell, HouseGreyjoy]
      },
      # Order of player houses does not influence track position
      {
        :houses => [HouseMartell, HouseTyrell, HouseGreyjoy, HouseBaratheon, HouseLannister, HouseStark],
        :iron_throne_track => [HouseBaratheon, HouseLannister, HouseStark, HouseMartell, HouseGreyjoy, HouseTyrell],
        :fiefdoms_track => [HouseGreyjoy, HouseTyrell, HouseMartell, HouseStark, HouseBaratheon, HouseLannister],
        :kings_court_track => [HouseLannister, HouseStark, HouseMartell, HouseBaratheon, HouseTyrell, HouseGreyjoy]
      },
      # Default track position for 5 players
      {
        :houses => [HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy, HouseTyrell],
        :iron_throne_track => [HouseBaratheon, HouseLannister, HouseStark, HouseGreyjoy, HouseTyrell],
        :fiefdoms_track => [HouseGreyjoy, HouseTyrell, HouseStark, HouseBaratheon, HouseLannister],
        :kings_court_track => [HouseLannister, HouseStark, HouseBaratheon, HouseTyrell, HouseGreyjoy]
      },
      # Default track position for 4 players
      {
        :houses => [HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy],
        :iron_throne_track => [HouseBaratheon, HouseLannister, HouseStark, HouseGreyjoy],
        :fiefdoms_track => [HouseGreyjoy, HouseStark, HouseBaratheon, HouseLannister],
        :kings_court_track => [HouseLannister, HouseStark, HouseBaratheon, HouseGreyjoy]
      },
      # Default track position for 3 players
      {
        :houses => [HouseStark, HouseLannister, HouseBaratheon],
        :iron_throne_track => [HouseBaratheon, HouseLannister, HouseStark],
        :fiefdoms_track => [HouseStark, HouseBaratheon, HouseLannister],
        :kings_court_track => [HouseLannister, HouseStark, HouseBaratheon]
      }
    ]
    data.each do |datum|
      iron_throne_track = IronThroneTrack.create_new(datum[:houses])
      fiefdoms_track = FiefdomsTrack.create_new(datum[:houses])
      kings_court_track = KingsCourtTrack.create_new(datum[:houses])

      assert_equal(datum[:iron_throne_track], iron_throne_track.track)
      assert_equal(datum[:fiefdoms_track], fiefdoms_track.track)
      assert_equal(datum[:kings_court_track], kings_court_track.track)
    end
  end

  def test_equality
    h1 = [HouseStark, HouseLannister, HouseBaratheon]
    h2 = [HouseStark, HouseLannister, HouseBaratheon]
    h3 = [HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy]
    tracks = [IronThroneTrack, FiefdomsTrack, KingsCourtTrack]
    tracks.each do |track|
      assert_equal(track.create_new(h1), track.create_new(h1))
      assert_equal(track.create_new(h1), track.create_new(h2))
      refute_equal(track.create_new(h1), track.create_new(h3))
    end
  end

  def test_next_player
    t = IronThroneTrack.new([HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy, HouseTyrell, HouseMartell])
    assert_equal(HouseLannister, t.next_player(HouseStark))
    assert_equal(HouseLannister, t.next_player(HouseStark, true))
    assert_equal(HouseLannister, t.next_player(HouseStark, false))
    assert_equal(HouseBaratheon, t.next_player(HouseLannister))
    assert_equal(HouseBaratheon, t.next_player(HouseLannister, true))
    assert_equal(HouseBaratheon, t.next_player(HouseLannister, false))
    assert_equal(HouseGreyjoy, t.next_player(HouseBaratheon))
    assert_equal(HouseGreyjoy, t.next_player(HouseBaratheon, true))
    assert_equal(HouseGreyjoy, t.next_player(HouseBaratheon, false))
    assert_equal(HouseTyrell, t.next_player(HouseGreyjoy))
    assert_equal(HouseTyrell, t.next_player(HouseGreyjoy, true))
    assert_equal(HouseTyrell, t.next_player(HouseGreyjoy, false))
    assert_equal(HouseMartell, t.next_player(HouseTyrell))
    assert_equal(HouseMartell, t.next_player(HouseTyrell, true))
    assert_equal(HouseMartell, t.next_player(HouseTyrell, false))
    assert_equal(HouseStark, t.next_player(HouseMartell))
    assert_equal(HouseStark, t.next_player(HouseMartell, true))
    assert_equal(nil, t.next_player(HouseMartell, false))
  end

  def test_kings_court_orders
    data = [
      { HouseStark => 3, HouseLannister => 3, HouseBaratheon => 1, HouseGreyjoy => 0, HouseTyrell => 0, HouseMartell => 2 },
      { HouseStark => 3, HouseLannister => 3, HouseBaratheon => 2, HouseGreyjoy => 0, HouseTyrell => 1 },
      { HouseStark => 2, HouseLannister => 3, HouseBaratheon => 1, HouseGreyjoy => 0 },
      { HouseStark => 2, HouseLannister => 3, HouseBaratheon => 1 }
    ]
    data.each do |datum|
      track = KingsCourtTrack.create_new(datum.keys)
      datum.each do |house_class, special_orders_allowed|
        assert_equal(special_orders_allowed, track.special_orders_allowed(house_class), house_class.to_s + ' is allowed wrong number of special orders')
      end
    end
  end
end
