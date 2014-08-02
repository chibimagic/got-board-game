class TestSupplyTrack < MiniTest::Test
  def test_initialize
    s = SupplyTrack.create_new(Game::HOUSE_CLASSES)
    expected_track = {
      0 => [],
      1 => [HouseStark],
      2 => [HouseLannister, HouseBaratheon, HouseGreyjoy, HouseTyrell, HouseMartell],
      3 => [],
      4 => [],
      5 => [],
      6 => [],
    }
    assert_equal(expected_track, s.track)
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
      },
      {
        0 => [],
        1 => [HouseStark],
        2 => [HouseStark],
        3 => [HouseStark],
        4 => [HouseStark],
        5 => [HouseStark],
        6 => [HouseStark],
      }
    ]
    data.each do |datum|
      e = assert_raises(RuntimeError) { SupplyTrack.new(datum) }
      assert_equal('Invalid track', e.message)
    end
  end

  def test_level_houses
    s = SupplyTrack.new({
      0 => [],
      1 => [HouseStark],
      2 => [HouseLannister],
      3 => [HouseBaratheon],
      4 => [HouseGreyjoy],
      5 => [HouseTyrell],
      6 => [HouseMartell],
    })

    assert_equal(1, s.level(HouseStark))
    assert_equal(2, s.level(HouseLannister))
    assert_equal(3, s.level(HouseBaratheon))
    assert_equal(4, s.level(HouseGreyjoy))
    assert_equal(5, s.level(HouseTyrell))
    assert_equal(6, s.level(HouseMartell))

    assert_equal([HouseStark], s.houses(1))
    assert_equal([HouseLannister], s.houses(2))
    assert_equal([HouseBaratheon], s.houses(3))
    assert_equal([HouseGreyjoy], s.houses(4))
    assert_equal([HouseTyrell], s.houses(5))
    assert_equal([HouseMartell], s.houses(6))
  end

  def test_set_level
    s = SupplyTrack.new({
      0 => [],
      1 => [HouseStark],
      2 => [HouseLannister],
      3 => [HouseBaratheon],
      4 => [HouseGreyjoy],
      5 => [HouseTyrell],
      6 => [HouseMartell],
    })

    s.set_level(HouseStark, 6)
    s.set_level(HouseLannister, 5)
    s.set_level(HouseBaratheon, 5)
    s.set_level(HouseGreyjoy, 0)
    s.set_level(HouseGreyjoy, 4)
    s.set_level(HouseTyrell, 0)

    expected_track = {
      0 => [HouseTyrell],
      1 => [],
      2 => [],
      3 => [],
      4 => [HouseGreyjoy],
      5 => [HouseLannister, HouseBaratheon],
      6 => [HouseMartell, HouseStark],
    }

    assert_equal(expected_track, s.track)
  end

  def test_armies_allowed
    s = SupplyTrack.new({
      0 => [],
      1 => [HouseMartell],
      2 => [HouseTyrell],
      3 => [HouseGreyjoy],
      4 => [HouseBaratheon],
      5 => [HouseLannister],
      6 => [HouseStark],
    })

    assert_equal([3, 2], s.armies_allowed(HouseMartell))
    assert_equal([3, 2, 2], s.armies_allowed(HouseTyrell))
    assert_equal([3, 2, 2, 2], s.armies_allowed(HouseGreyjoy))
    assert_equal([3, 3, 2, 2], s.armies_allowed(HouseBaratheon))
    assert_equal([4, 3, 2, 2], s.armies_allowed(HouseLannister))
    assert_equal([4, 3, 2, 2, 2], s.armies_allowed(HouseStark))
  end
end
