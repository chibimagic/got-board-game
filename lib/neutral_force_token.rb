class NeutralForceToken < Token
  attr_reader :area_class, :strength

  def initialize(area_class, strength)
    @area_class = area_class
    @strength = strength
  end

  def self.unserialize(data)
  end

  def serialize
    { self.class => @strength }
  end

  def ==(o)
    self.class == o.class &&
      self.area_class == o.area_class &&
      self.strength == o.strength
  end

  def to_s
    @area_class.to_s + ' (' + @strength.to_s + ')'
  end

  def house
    HouseIndependent.new
  end
end
