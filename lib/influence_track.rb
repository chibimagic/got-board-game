class InfluenceTrack
  attr_reader :track

  def initialize(track)
    raise 'Invalid track' unless track.is_a?(Array) && track.all? { |house_class| house_class < House }

    @track = track
  end

  def self.create_new(house_classes)
    track = Array.new(6)
    house_classes.each do |house_class|
      position = house_class::STARTING_POSITIONS[self]
      track[position - 1] = house_class
    end
    track.compact! # Fill in empty spots from missing houses

    new(track)
  end

  def self.unserialize(data)
    track = data.map { |house_class_string| house_class_string.constantize }
    new(track)
  end

  def serialize
    @track.map { |house_class| house_class.name }
  end

  def ==(o)
    self.class == o.class &&
      @track == o.track
  end

  def token_holder_class
    @track[0]
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
