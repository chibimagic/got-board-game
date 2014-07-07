class Unit < HouseToken
  MUSTERING_COST = 0
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
