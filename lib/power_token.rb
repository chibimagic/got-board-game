class PowerToken
  attr_reader :house

  def initialize(house)
    @house = house
  end

  def to_s
    'Power Token (' + @house.class.to_s + ')'
  end
end
