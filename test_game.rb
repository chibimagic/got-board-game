require 'test/unit'
require_relative 'game.rb'

class TestGame < Test::Unit::TestCase
  def test_initialize_invalid
    # Game must be initialized with players
    assert_raise(ArgumentError) { Game.new }
    assert_raise(RuntimeError) { Game.new({}) }
    assert_raise(RuntimeError) { Game.new([]) }
  end

  def test_game_setup
    players = [
      Player.new('a', HouseStark),
      Player.new('b', HouseLannister),
      Player.new('c', HouseBaratheon)
    ]
    game = Game.new(players)
    assert_equal(3, game.players.length)
    assert_equal(1, game.game_round)
    assert_equal(:planning, game.round_phase)
  end

  def test_house_selection_valid
    data = [
      [HouseStark, HouseLannister, HouseBaratheon],
      [HouseMartell, HouseTyrell, HouseGreyjoy, HouseBaratheon, HouseLannister, HouseStark]
    ]
    data.each do |datum|
      assert_nothing_raised {
        players = []
        datum.each do |house|
          players.push(Player.new(nil, house))
        end
        g = Game.new(players)
      }
    end
  end

  def test_house_selection_invalid
    data = [
      # Can't choose the same house more than once
      [HouseStark, HouseStark, HouseStark],
      [HouseStark, HouseStark, HouseLannister],
      [HouseStark, HouseLannister, HouseStark],
      # Can't choose House Greyjoy/Tyrell/Martell in a 3 player game
      [HouseStark, HouseLannister, HouseGreyjoy],
      [HouseStark, HouseLannister, HouseTyrell],
      [HouseStark, HouseLannister, HouseMartell],
      # Can't choose House Tyrell/Martell in a 4 player game
      [HouseStark, HouseLannister, HouseBaratheon, HouseTyrell],
      [HouseStark, HouseLannister, HouseBaratheon, HouseMartell],
      # Can't choose House Martell in a 5 player game
      [HouseStark, HouseLannister, HouseBaratheon, HouseGreyjoy, HouseMartell]
    ]
    data.each do |datum|
      assert_raise(RuntimeError) {
        players = []
        datum.each do |house|
          players.push(Player.new(nil, house))
        end
        g = Game.new(players)
      }
    end
  end
end
