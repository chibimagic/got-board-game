class GarrisonToken
  attr_reader :house

  def initialize(house)
    @house = house
  end

  def strength
    2
  end
end
