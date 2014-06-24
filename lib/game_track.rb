require 'set'

class GameTrack
end

class WildlingTrack < GameTrack
  attr_reader :strength

  def initialize
    @strength = 2
  end

  def increase
    @strength = [@strength + 2, 12].min
  end

  def nights_watch_victory
    @strength = 0
  end

  def wildling_victory
    @strength = [@strength - 4, 0].max
  end
end

class InfluenceTrack < GameTrack
  attr_reader :track

  def initialize(players)
    @track = Array.new(6)
    players.each do |player|
      position = player.house.class::STARTING_POSITIONS[self.class]
      @track[position - 1] = player.house.class
    end
    @track.delete(nil) # Fill in empty spots from missing players
  end
end

class IronThroneTrack < InfluenceTrack
end

class FiefdomsTrack < InfluenceTrack
end

class KingsCourtTrack < InfluenceTrack
end

class SupplyTrack < GameTrack
  ARMIES_ALLOWED = {
    0 => [2, 2],
    1 => [3, 2],
    2 => [3, 2, 2],
    3 => [3, 2, 2, 2],
    4 => [3, 3, 2, 2],
    5 => [4, 3, 2, 2],
    6 => [4, 3, 2, 2, 2]
  }

  def initialize(players)
    @houses = Hash.new
    players.each do |player|
      @houses[player.house.class] = 2
    end
  end

  def set_supply(house_class, new_supply)
    @houses[house_class] = new_supply
  end

  def get_supply(house_class)
    @houses[house_class]
  end

  def armies_allowed(house_class)
    supply = get_supply(house_class)
    self.class::ARMIES_ALLOWED[supply]
  end

  def get_houses(requested_supply)
    @houses.select { |house, supply| supply == requested_supply }.keys.to_set
  end
end
