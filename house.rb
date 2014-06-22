class House
  HOUSE_NAME = ''
  MINIMUM_PLAYERS = 3

  def self.to_s
    'House ' + self::HOUSE_NAME
  end

  def to_s
    'House ' + self.class::HOUSE_NAME
  end
end

class HouseStark < House
  HOUSE_NAME = 'Stark'
end

class HouseLannister < House
  HOUSE_NAME = 'Lannister'
end

class HouseBaratheon < House
  HOUSE_NAME = 'Baratheon'
end

class HouseGreyjoy < House
  HOUSE_NAME = 'Greyjoy'
  MINIMUM_PLAYERS = 4
end

class HouseTyrell < House
  HOUSE_NAME = 'Tyrell'
  MINIMUM_PLAYERS = 5
end

class HouseMartell < House
  HOUSE_NAME = 'Martell'
  MINIMUM_PLAYERS = 6
end
