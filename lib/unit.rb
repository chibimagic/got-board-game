class Unit
  attr_reader :house

  MUSTERING_COST = 0

  def initialize(house)
    @house = house
  end

  def to_s
    self.class::TITLE
  end
end

class Footman < Unit
  TITLE = 'Footman'
  MUSTERING_COST = 1
end

class Knight < Unit
  TITLE = 'Knight'
  MUSTERING_COST = 2
end

class Ship < Unit
  TITLE = 'Ship'
  MUSTERING_COST = 1
end

class SiegeEngine < Unit
  TITLE = 'Siege Engine'
  MUSTERING_COST = 2
end
