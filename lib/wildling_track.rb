class WildlingTrack
  attr_reader :strength

  def initialize(strength)
    raise 'Invalid strength' unless strength.is_a?(Integer) && 0 <= strength && strength <= 12 && strength.even?

    @strength = strength
  end

  def self.create_new
    strength = 2
    new(strength)
  end

  def self.unserialize(data)
    strength = data
    new(strength)
  end

  def serialize
    @strength
  end

  def ==(o)
    self.class == o.class &&
      @strength == o.strength
  end

  def increase
    @strength = [@strength + 2, 12].min
  end

  def attacks?
    @strength == 12
  end

  def nights_watch_victory
    @strength = 0
  end

  def wildling_victory
    @strength = [@strength - 4, 0].max
  end
end
