class Player
  attr_reader :name, :house

  def initialize(name, house_class)
    @name = name
    @house = house_class.new
  end

  def to_s
    @name.to_s + ' (' + @house.to_s + ')'
  end
end
