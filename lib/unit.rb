class Unit < HouseToken
  attr_reader :routed

  MUSTERING_COST = 0

  def initialize(house_class, routed)
    raise 'Invalid routed' unless [true, false].include?(routed)

    super(house_class)
    @routed = routed
  end

  def self.create_new(house_class)
    routed = false

    new(house_class, routed)
  end

  def self.unserialize(data)
    token_class_string = data.keys[0]
    house_class_string = data.values[0][0]
    routed = data.values[0][1]
    token_class_string.constantize.new(house_class_string.constantize, routed)
  end

  def serialize
    { self.class.name => [@house_class.name, routed] }
  end

  def ==(o)
    self.class == o.class &&
      @house_class == o.house_class &&
      @routed == o.routed
  end

  def route
    @routed = true
  end

  def reset
    @routed = false
  end
end

class Footman < Unit
  TITLE = 'Footman'
  MUSTERING_COST = 1
end

class Knight < Unit
  TITLE = 'Knight'
  MUSTERING_COST = 2
end

class Ship < Unit
  TITLE = 'Ship'
  MUSTERING_COST = 1
end

class SiegeEngine < Unit
  TITLE = 'Siege Engine'
  MUSTERING_COST = 2
end
