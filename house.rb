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

  STARTING_POSITIONS = {
    IronThroneTrack => 3,
    FiefdomsTrack => 4,
    KingsCourtTrack => 2
  }
end

class HouseLannister < House
  HOUSE_NAME = 'Lannister'

  STARTING_POSITIONS = {
    IronThroneTrack => 2,
    FiefdomsTrack => 6,
    KingsCourtTrack => 1
  }
end

class HouseBaratheon < House
  HOUSE_NAME = 'Baratheon'

  STARTING_POSITIONS = {
    IronThroneTrack => 1,
    FiefdomsTrack => 5,
    KingsCourtTrack => 4
  }
end

class HouseGreyjoy < House
  HOUSE_NAME = 'Greyjoy'
  MINIMUM_PLAYERS = 4

  STARTING_POSITIONS = {
    IronThroneTrack => 5,
    FiefdomsTrack => 1,
    KingsCourtTrack => 6
  }
end

class HouseTyrell < House
  HOUSE_NAME = 'Tyrell'
  MINIMUM_PLAYERS = 5

  STARTING_POSITIONS = {
    IronThroneTrack => 6,
    FiefdomsTrack => 2,
    KingsCourtTrack => 5
  }
end

class HouseMartell < House
  HOUSE_NAME = 'Martell'
  MINIMUM_PLAYERS = 6

  STARTING_POSITIONS = {
    IronThroneTrack => 4,
    FiefdomsTrack => 3,
    KingsCourtTrack => 3
  }
end
