class TestWildlingTrack < MiniTest::Test
  def setup
    @track = WildlingTrack.create_new
  end
  def test_wildling_track_initialize
    assert_equal(2, @track.strength, "Wildling track should start at 2")
  end

  def test_equality
    w1 = WildlingTrack.create_new
    w2 = WildlingTrack.create_new
    assert_equal(w1, w2)

    w2.increase
    refute_equal(w1, w2)

    w2.nights_watch_victory
    w2.increase
    assert_equal(w1, w2)
  end

  def test_wildling_track_increase
    @track.increase
    assert_equal(4, @track.strength, "Wildling track should increase by 2 each time")
    @track.increase
    assert_equal(6, @track.strength, "Wildling track should increase by 2 each time")
    @track.increase
    assert_equal(8, @track.strength, "Wildling track should increase by 2 each time")
    @track.increase
    assert_equal(10, @track.strength, "Wildling track should increase by 2 each time")
    @track.increase
    assert_equal(12, @track.strength, "Wildling track should increase by 2 each time")
    @track.increase
    assert_equal(12, @track.strength, "Wildling track should max out at 12")
  end

  def test_wildling_track_victory
    @track.increase # 4
    @track.increase # 6
    @track.increase # 8
    @track.nights_watch_victory
    assert_equal(0, @track.strength, "Wildling track should be at 0 after a Night's Watch victory")
    @track.increase # 2
    @track.increase # 4
    @track.increase # 6
    @track.wildling_victory
    assert_equal(2, @track.strength, "Wildling track should be set back 2 positions after a Wildling victory")
    @track.wildling_victory
    assert_equal(0, @track.strength, "Wildling track should be set back to a minimum of 0 after a Wildling victory")
    @track.wildling_victory
    assert_equal(0, @track.strength, "Wildling track should be set back to a minimum of 0 after a Wildling victory")
  end
end
