class NeutralForceToken
  attr_reader :location_class, :strength

  def initialize(location_class, strength)
    @location_class = location_class
    @strength = strength
  end

  def to_s
    @location_class.to_s + ' (' + strength.to_s + ')'
  end
end
