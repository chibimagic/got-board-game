class House
  attr_reader :units

  HOUSE_NAME = ''
  MINIMUM_PLAYERS = 3

  def initialize
    @units = [].to_set
    10.times { @units.add(Footman.new(self)) }
    5.times { @units.add(Knight.new(self)) }
    6.times { @units.add(Ship.new(self)) }
    2.times { @units.add(SiegeEngine.new(self)) }
  end

  def self.to_s
    'House ' + self::HOUSE_NAME
  end

  def to_s
    'House ' + self.class::HOUSE_NAME
  end
end

# This represents the house for neutral house tokens
class HouseIndependent < House
  HOUSE_NAME = 'Independent'
end

class HouseStark < House
  HOUSE_NAME = 'Stark'
  INITIAL_SUPPLY = 1

  STARTING_UNITS = {
    Winterfell => [Knight, Footman],
    WhiteHarbor => [Footman],
    TheShiveringSea => [Ship]
  }

  STARTING_POSITIONS = {
    IronThroneTrack => 3,
    FiefdomsTrack => 4,
    KingsCourtTrack => 2
  }
end

class HouseLannister < House
  HOUSE_NAME = 'Lannister'
  INITIAL_SUPPLY = 2

  STARTING_UNITS = {
    Lannisport => [Knight, Footman],
    StoneySept => [Footman],
    TheGoldenSound => [Ship]
  }

  STARTING_POSITIONS = {
    IronThroneTrack => 2,
    FiefdomsTrack => 6,
    KingsCourtTrack => 1
  }
end

class HouseBaratheon < House
  HOUSE_NAME = 'Baratheon'
  INITIAL_SUPPLY = 2

  STARTING_UNITS = {
    Dragonstone => [Knight, Footman],
    Kingswood => [Footman],
    ShipbreakerBay => [Ship, Ship]
  }

  STARTING_POSITIONS = {
    IronThroneTrack => 1,
    FiefdomsTrack => 5,
    KingsCourtTrack => 4
  }
end

class HouseGreyjoy < House
  HOUSE_NAME = 'Greyjoy'
  MINIMUM_PLAYERS = 4
  INITIAL_SUPPLY = 2

  STARTING_UNITS = {
    Pyke => [Knight, Footman, Ship],
    GreywaterWatch => [Footman],
    IronmansBay => [Ship]
  }

  STARTING_POSITIONS = {
    IronThroneTrack => 5,
    FiefdomsTrack => 1,
    KingsCourtTrack => 6
  }
end

class HouseTyrell < House
  HOUSE_NAME = 'Tyrell'
  MINIMUM_PLAYERS = 5
  INITIAL_SUPPLY = 2

  STARTING_UNITS = {
    Highgarden => [Knight, Footman],
    DornishMarches => [Footman],
    RedwyneStraits => [Ship]
  }

  STARTING_POSITIONS = {
    IronThroneTrack => 6,
    FiefdomsTrack => 2,
    KingsCourtTrack => 5
  }
end

class HouseMartell < House
  HOUSE_NAME = 'Martell'
  MINIMUM_PLAYERS = 6
  INITIAL_SUPPLY = 2

  STARTING_UNITS = {
    Sunspear => [Knight, Footman],
    SaltShore => [Footman],
    SeaOfDorne => [Ship]
  }

  STARTING_POSITIONS = {
    IronThroneTrack => 4,
    FiefdomsTrack => 3,
    KingsCourtTrack => 3
  }
end
