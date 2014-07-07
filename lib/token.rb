class Token
end

class HouseToken < Token
  attr_reader :house_class

  TITLE = 'House Token'

  def initialize(house_class)
    unless house_class.is_a?(Class) && house_class < House
      raise self.class.to_s + ' must be instantiated with a House class'
    end
    @house_class = house_class
  end

  def ==(o)
    self.class == o.class &&
      @house_class == o.house_class
  end

  def self.unserialize(data)
  end

  def serialize
    { self.class => @house_class }
  end

  def to_s
    self.class::TITLE + ' (' + @house_class.to_s + ')'
  end
end
