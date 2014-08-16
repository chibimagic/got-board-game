class InfluenceTrack
  attr_reader :track

  TITLE = 'Influence'

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

  def to_s
    self.class::TITLE + ' track'
  end

  def token_holder_class
    @track[0]
  end

  # Returns 1-based index
  def position(house_class)
    @track.find_index(house_class) + 1
  end

  def move_to_top(house_class)
    @track.delete(house_class)
    @track.unshift(house_class)
  end

  def move_to_bottom(house_class)
    @track.delete(house_class)
    @track.push(house_class)
  end
end

class IronThroneTrack < InfluenceTrack
  TITLE = 'Iron Throne'

  def next_player(house_class, wrap_around = true)
    unless @track.include?(house_class)
      raise house_class.to_s + ' is not in ' + to_s
    end

    current_index = @track.find_index(house_class)

    if current_index + 1 == @track.length
      wrap_around ? @track[0] : nil
    else
      @track[current_index + 1]
    end
  end
end

class FiefdomsTrack < InfluenceTrack
  TITLE = 'Fiefdoms'
end

class KingsCourtTrack < InfluenceTrack
  attr_reader :special_orders

  TITLE = 'King\'s Court'
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
