class Token
end

class HouseToken < Token
  attr_reader :house

  def initialize(house)
    @house = house
  end

  def ==(o)
    self.class == o.class &&
      @house == o.house
  end

  def self.unserialize(data)
  end

  def serialize
    { self.class => @house.class }
  end

  def to_s
    self.class::TITLE + ' (' + @house.class.to_s + ')'
  end
end
