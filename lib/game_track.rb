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

  # Returns 1-based index
  def position(house_class)
    @track.find_index(house_class) + 1
  end
end

class IronThroneTrack < InfluenceTrack
end

class FiefdomsTrack < InfluenceTrack
end

class KingsCourtTrack < InfluenceTrack
  attr_reader :special_orders
  FIVE_SIX_PLAYER_SPECIAL_ORDERS = [3, 3, 2, 1, 0, 0]
  THREE_FOUR_PLAYER_SPECIAL_ORDERS = [3, 2, 1, 0]

  def initialize(players)
    super(players)
    case players.count
    when 3..4
      @special_orders = THREE_FOUR_PLAYER_SPECIAL_ORDERS
    when 5..6
      @special_orders = FIVE_SIX_PLAYER_SPECIAL_ORDERS
    end
  end

  def special_orders_allowed(house_class)
    index = position(house_class) - 1
    @special_orders[index]
  end
end
