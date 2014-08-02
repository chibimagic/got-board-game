class SupplyTrack
  attr_reader :track

  ARMIES_ALLOWED = {
    0 => [2, 2],
    1 => [3, 2],
    2 => [3, 2, 2],
    3 => [3, 2, 2, 2],
    4 => [3, 3, 2, 2],
    5 => [4, 3, 2, 2],
    6 => [4, 3, 2, 2, 2]
  }

  def initialize(track)
    unless track.is_a?(Hash) &&
      track.keys == (0..6).to_a &&
      track.values.all? { |v| v.is_a?(Array) && v.all? { |house_class| house_class.class == Class && house_class < House } } &&
      track.values.flatten.uniq == track.values.flatten
      raise 'Invalid track'
    end

    @track = track
  end

  def self.create_new(house_classes)
    track = {
      0 => [],
      1 => [],
      2 => [],
      3 => [],
      4 => [],
      5 => [],
      6 => [],
    }
    house_classes.each do |house_class|
      position = house_class::STARTING_POSITIONS[self]
      track[position].push(house_class)
    end

    new(track)
  end

  def self.unserialize(data)
    track = Hash[data.map { |supply_level, house_class_strings| [supply_level.to_i, house_class_strings.map { |house_class_string| house_class_string.constantize }] }]
    new(track)
  end

  def serialize
    Hash[track.map { |supply_level, house_classes| [supply_level, house_classes.map { |house_class| house_class.name }] }]
  end

  def ==(o)
    self.class == o.class &&
      @track == o.track
  end

  def level(house_class)
    track.select { |supply_level, house_classes| house_classes.include?(house_class) }.keys.first
  end

  def houses(supply_level)
    track.fetch(supply_level, [])
  end

  def set_level(house_class, new_supply_level)
    track.each_value { |v| v.delete(house_class) }
    track.fetch(new_supply_level).push(house_class)
  end

  def armies_allowed(house_class)
    ARMIES_ALLOWED.fetch(level(house_class))
  end
end
