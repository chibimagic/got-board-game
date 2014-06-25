class Unit
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
