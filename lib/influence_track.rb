class InfluenceTrack
  attr_reader :track

  def initialize(houses)
    @track = Array.new(6)
    houses.each do |house|
      position = house.class::STARTING_POSITIONS[self.class]
      @track[position - 1] = house.class
    end
    @track.delete(nil) # Fill in empty spots from missing houses
  end

  def self.unserialize(data)
  end

  def serialize
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

  def initialize(houses)
    super(houses)
    case houses.count
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
