class TestInfluenceTrack < Test::Unit::TestCase
  def test_initialize
    data = [
      # Default track position for full board
      {
        :players => [HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy, HouseTyrell, HouseMartell],
        :iron_throne_track => [HouseBaratheon, HouseLannister, HouseStark, HouseMartell, HouseGreyjoy, HouseTyrell],
        :fiefdoms_track => [HouseGreyjoy, HouseTyrell, HouseMartell, HouseStark, HouseBaratheon, HouseLannister],
        :kings_court_track => [HouseLannister, HouseStark, HouseMartell, HouseBaratheon, HouseTyrell, HouseGreyjoy]
      },
      # Order of player houses does not influence track position
      {
        :players => [HouseMartell, HouseTyrell, HouseGreyjoy, HouseBaratheon, HouseLannister, HouseStark],
        :iron_throne_track => [HouseBaratheon, HouseLannister, HouseStark, HouseMartell, HouseGreyjoy, HouseTyrell],
        :fiefdoms_track => [HouseGreyjoy, HouseTyrell, HouseMartell, HouseStark, HouseBaratheon, HouseLannister],
        :kings_court_track => [HouseLannister, HouseStark, HouseMartell, HouseBaratheon, HouseTyrell, HouseGreyjoy]
      },
      # Default track position for 5 players
      {
        :players => [HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy, HouseTyrell],
        :iron_throne_track => [HouseBaratheon, HouseLannister, HouseStark, HouseGreyjoy, HouseTyrell],
        :fiefdoms_track => [HouseGreyjoy, HouseTyrell, HouseStark, HouseBaratheon, HouseLannister],
        :kings_court_track => [HouseLannister, HouseStark, HouseBaratheon, HouseTyrell, HouseGreyjoy]
      },
      # Default track position for 4 players
      {
        :players => [HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy],
        :iron_throne_track => [HouseBaratheon, HouseLannister, HouseStark, HouseGreyjoy],
        :fiefdoms_track => [HouseGreyjoy, HouseStark, HouseBaratheon, HouseLannister],
        :kings_court_track => [HouseLannister, HouseStark, HouseBaratheon, HouseGreyjoy]
      },
      # Default track position for 3 players
      {
        :players => [HouseStark, HouseLannister, HouseBaratheon],
        :iron_throne_track => [HouseBaratheon, HouseLannister, HouseStark],
        :fiefdoms_track => [HouseStark, HouseBaratheon, HouseLannister],
        :kings_court_track => [HouseLannister, HouseStark, HouseBaratheon]
      }
    ]
    data.each do |datum|
      players = datum[:players].map { |house| Player.new('', house) }
      iron_throne_track = IronThroneTrack.new(players)
      fiefdoms_track = FiefdomsTrack.new(players)
      kings_court_track = KingsCourtTrack.new(players)

      assert_equal(datum[:iron_throne_track], iron_throne_track.track)
      assert_equal(datum[:fiefdoms_track], fiefdoms_track.track)
      assert_equal(datum[:kings_court_track], kings_court_track.track)
    end
  end

  def test_kings_court_orders
    data = [
      { HouseStark => 3, HouseLannister => 3, HouseBaratheon => 1, HouseGreyjoy => 0, HouseTyrell => 0, HouseMartell => 2 },
      { HouseStark => 3, HouseLannister => 3, HouseBaratheon => 2, HouseGreyjoy => 0, HouseTyrell => 1 },
      { HouseStark => 2, HouseLannister => 3, HouseBaratheon => 1, HouseGreyjoy => 0 },
      { HouseStark => 2, HouseLannister => 3, HouseBaratheon => 1 }
    ]
    data.each do |datum|
      players = datum.map { |house_class, special_orders_allowed| Player.new('', house_class) }
      track = KingsCourtTrack.new(players)
      datum.each do |house_class, special_orders_allowed|
        assert_equal(special_orders_allowed, track.special_orders_allowed(house_class), house_class.to_s + ' is allowed wrong number of special orders')
      end
    end
  end
end
