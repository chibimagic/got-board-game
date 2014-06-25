class Unit
  attr_reader :house

  def initialize(house)
    @house = house
  end

  def to_s
    self.class::TITLE
  end
end

class Footman < Unit
  TITLE = 'Footman'
end

class Knight < Unit
  TITLE = 'Knight'
end

class Ship < Unit
  TITLE = 'Ship'
end

class SiegeEngine < Unit
  TITLE = 'Siege Engine'
end
