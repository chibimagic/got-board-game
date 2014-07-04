class GarrisonToken
  attr_reader :house

  def initialize(house)
    @house = house
  end

  def self.unserialize(data)
  end

  def serialize
    { self.class => @house.class }
  end

  def strength
    2
  end
end
