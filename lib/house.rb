class House
  include TokenHolder

  TITLE = ''
  MINIMUM_PLAYERS = 3

  def initialize(tokens)
    raise 'Invalid tokens' unless tokens.is_a?(Array) && tokens.all? { |token| token.is_a?(HouseToken) }

    @tokens = tokens
  end

  def self.create_new
    tokens = []

    10.times { tokens.push(Footman.create_new(self)) }
    5.times { tokens.push(Knight.create_new(self)) }
    6.times { tokens.push(Ship.create_new(self)) }
    2.times { tokens.push(SiegeEngine.create_new(self)) }

    5.times { tokens.push(PowerToken.new(self)) }

    tokens.push(
      WeakMarchOrder.new(self),
      MarchOrder.new(self),
      SpecialMarchOrder.new(self),
      DefenseOrder.new(self),
      DefenseOrder.new(self),
      SpecialDefenseOrder.new(self),
      SupportOrder.new(self),
      SupportOrder.new(self),
      SpecialSupportOrder.new(self),
      RaidOrder.new(self),
      RaidOrder.new(self),
      SpecialRaidOrder.new(self),
      ConsolidatePowerOrder.new(self),
      ConsolidatePowerOrder.new(self),
      SpecialConsolidatePowerOrder.new(self),
    )
    new(tokens)
  end

  def self.unserialize(data)
    tokens = data.map { |token_data| Token.unserialize(token_data) }
    new(tokens)
  end

  def serialize
    @tokens.map { |token| token.serialize }
  end

  def ==(o)
    self.class == o.class &&
      @tokens == o.tokens
  end

  def self.to_s
    self::TITLE
  end

  def to_s
    self.class::TITLE
  end

  def get_tokens(token_class)
    @tokens.find_all { |token| token.is_a?(token_class) }
  end
end

# This represents the house for neutral house tokens
class HouseIndependent < House
  TITLE = 'Independent Houses'

  def initialize
  end
end

class HouseStark < House
  TITLE = 'House Stark'
  HOME_AREA = Winterfell
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
  TITLE = 'House Lannister'
  HOME_AREA = Lannisport
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
  TITLE = 'House Baratheon'
  HOME_AREA = Dragonstone
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
  TITLE = 'House Greyjoy'
  HOME_AREA = Pyke
  MINIMUM_PLAYERS = 4
  INITIAL_SUPPLY = 2

  STARTING_UNITS = {
    Pyke => [Knight, Footman],
    PykePortToIronmansBay => [Ship],
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
  TITLE = 'House Tyrell'
  HOME_AREA = Highgarden
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
  TITLE = 'House Martell'
  HOME_AREA = Sunspear
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
