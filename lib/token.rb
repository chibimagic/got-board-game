class Token
  def self.unserialize(data)
    token_class_string = data.keys[0]
    token_class_string.constantize.unserialize(data)
  end
end

class HouseToken < Token
  attr_reader :house_class

  TITLE = 'House Token'

  def initialize(house_class)
    raise 'Invalid house class' unless house_class.is_a?(Class) && house_class < House

    @house_class = house_class
  end

  def ==(o)
    self.class == o.class &&
      @house_class == o.house_class
  end

  def self.unserialize(data)
    token_class_string = data.keys[0]
    house_class_string = data.values[0]
    token_class_string.constantize.new(house_class_string.constantize)
  end

  def serialize
    { self.class => @house_class }
  end

  def to_s
    self.class::TITLE + ' (' + @house_class.to_s + ')'
  end
end
