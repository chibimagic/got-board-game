class WildlingTrack
  attr_reader :strength

  def initialize
    @strength = 2
  end

  def self.unserialize(data)
  end

  def serialize
    @strength
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
