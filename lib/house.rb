class House
  attr_reader :player_name, :tokens

  TITLE = ''
  MINIMUM_PLAYERS = 3

  def initialize(player_name, tokens)
    raise 'Invalid player name' unless player_name.is_a?(String)
    raise 'Invalid tokens' unless tokens.is_a?(Array) && tokens.all? { |token| token.is_a?(HouseToken) }

    @player_name = player_name
    @tokens = tokens
  end

  def self.create_new(player_name = '')
    tokens = []

    10.times { tokens.push(Footman.new(self)) }
    5.times { tokens.push(Knight.new(self)) }
    6.times { tokens.push(Ship.new(self)) }
    2.times { tokens.push(SiegeEngine.new(self)) }

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
    new(player_name, tokens)
  end

  def self.unserialize(data)
    house_class = data['house_class'].constantize
    player_name = data['player_name']
    tokens = data['tokens'].map { |token_data| HouseToken.unserialize(token_data) }

    house_class.new(player_name, tokens)
  end

  def serialize
    {
      :house_class => self.class.name,
      :player_name => @player_name,
      :tokens => @tokens.map { |token| token.serialize }
    }
  end

  def ==(o)
    self.class == o.class &&
      @player_name == o.player_name &&
      @tokens == o.tokens
  end

  def self.to_s
    self::TITLE
  end

  def to_s
    name = @player_name.length > 0 ? @player_name : 'no name'
    self.class::TITLE + ' (' + name + ')'
  end

  def units
    @tokens.find_all { |token| token.is_a?(Unit) }
  end

  def power_tokens
    @tokens.find_all { |token| token.is_a?(PowerToken) }
  end

  def order_tokens
    @tokens.find_all { |token| token.is_a?(OrderToken) }
  end

  def has_token?(token_class)
    @tokens.find { |token| token.is_a?(token_class) } ? true : false
  end

  def get_token(token_class)
    @tokens.find { |token| token.class == token_class }
  end

  def receive_token(token)
    @tokens.push(token)
  end

  def remove_token(token_class)
    if !has_token?(token_class)
      raise to_s + ' does not have any available ' + token_class.to_s
    end

    token = get_token(token_class)
    @tokens.delete_at(@tokens.index(token))
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
