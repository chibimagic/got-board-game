class TestGameTrack < Test::Unit::TestCase
  def setup
    players = [
      Player.new('a', HouseStark),
      Player.new('b', HouseLannister),
      Player.new('c', HouseBaratheon),
      Player.new('d', HouseGreyjoy),
      Player.new('e', HouseTyrell),
      Player.new('f', HouseMartell)
    ]
    @g = Game.new(players)
  end

  def test_wildling_track_initialize
    assert_equal(2, @g.wildling_track.strength, "Wildling track should start at 2")
  end

  def test_wildling_track_increase
    @g.wildling_track.increase
    assert_equal(4, @g.wildling_track.strength, "Wildling track should increase by 2 each time")
    @g.wildling_track.increase
    assert_equal(6, @g.wildling_track.strength, "Wildling track should increase by 2 each time")
    @g.wildling_track.increase
    assert_equal(8, @g.wildling_track.strength, "Wildling track should increase by 2 each time")
    @g.wildling_track.increase
    assert_equal(10, @g.wildling_track.strength, "Wildling track should increase by 2 each time")
    @g.wildling_track.increase
    assert_equal(12, @g.wildling_track.strength, "Wildling track should increase by 2 each time")
    @g.wildling_track.increase
    assert_equal(12, @g.wildling_track.strength, "Wildling track should max out at 12")
  end

  def test_wildling_track_victory
    @g.wildling_track.increase # 4
    @g.wildling_track.increase # 6
    @g.wildling_track.increase # 8
    @g.wildling_track.nights_watch_victory
    assert_equal(0, @g.wildling_track.strength, "Wildling track should be at 0 after a Night's Watch victory")
    @g.wildling_track.increase # 2
    @g.wildling_track.increase # 4
    @g.wildling_track.increase # 6
    @g.wildling_track.wildling_victory
    assert_equal(2, @g.wildling_track.strength, "Wildling track should be set back 2 positions after a Wildling victory")
    @g.wildling_track.wildling_victory
    assert_equal(0, @g.wildling_track.strength, "Wildling track should be set back to a minimum of 0 after a Wildling victory")
    @g.wildling_track.wildling_victory
    assert_equal(0, @g.wildling_track.strength, "Wildling track should be set back to a minimum of 0 after a Wildling victory")
  end

  def test_influence_track_initialize
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
end
