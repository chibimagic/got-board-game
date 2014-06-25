class Area
  attr_reader :tokens

  TITLE = ''
  CONNECTION_COUNT = 0
  STRONGHOLD = false
  CASTLE = false
  SUPPLY = 0
  POWER = 0
  PORT = false
  PORT_TO = nil

  def initialize
    @tokens = []
  end

  def self.to_s
    self::TITLE
  end

  def to_s
    self.class::TITLE
  end

  def connection_count
    self.class::CONNECTION_COUNT
  end

  def has_stronghold?
    self.class::STRONGHOLD
  end

  def has_castle?
    self.class::CASTLE
  end

  def supply
    self.class::SUPPLY
  end

  def power
    self.class::POWER
  end

  def has_port?
    self.class::PORT
  end

  def port_to
    self.class::PORT_TO
  end
end

class SeaArea < Area
end

class LandArea < Area
end

class BayOfIce < SeaArea
  TITLE = 'Bay of Ice'
  CONNECTION_COUNT = 6
end

class BlackwaterBay < SeaArea
  TITLE = 'Blackwater Bay'
  CONNECTION_COUNT = 4
end

class EastSummerSea < SeaArea
  TITLE = 'East Summer Sea'
  CONNECTION_COUNT = 7
end

class IronmansBay < SeaArea
  TITLE = 'Ironman\'s Bay'
  CONNECTION_COUNT = 7
end

class RedwyneStraits < SeaArea
  TITLE = 'Redwyne Straits'
  CONNECTION_COUNT = 5
end

class SeaOfDorne < SeaArea
  TITLE = 'Sea of Dorne'
  CONNECTION_COUNT = 5
end

class ShipbreakerBay < SeaArea
  TITLE = 'Shipbreaker Bay'
  CONNECTION_COUNT = 7
end

class SunsetSea < SeaArea
  TITLE = 'Sunset Sea'
  CONNECTION_COUNT = 6
end

class TheGoldenSound < SeaArea
  TITLE = 'The Golden Sound'
  CONNECTION_COUNT = 5
end

class TheNarrowSea < SeaArea
  TITLE = 'The Narrow Sea'
  CONNECTION_COUNT = 10
end

class TheShiveringSea < SeaArea
  TITLE = 'The Shivering Sea'
  CONNECTION_COUNT = 6
end

class WestSummerSea < SeaArea
  TITLE = 'West Summer Sea'
  CONNECTION_COUNT = 8
end

class Blackwater < LandArea
  TITLE = 'Blackwater'
  CONNECTION_COUNT = 6
  SUPPLY = 2
end

class CastleBlack < LandArea
  TITLE = 'Castle Black'
  CONNECTION_COUNT = 4
  POWER = 1
end

class CrackclawPoint < LandArea
  TITLE = 'Crackclaw Point'
  CONNECTION_COUNT = 7
  CASTLE = true
end

class DornishMarches < LandArea
  TITLE = 'Dornish Marches'
  CONNECTION_COUNT = 6
  POWER = 1
end

class Dragonstone < LandArea
  TITLE = 'Dragonstone'
  CONNECTION_COUNT = 1
  STRONGHOLD = true
  SUPPLY = 1
  POWER = 1
  PORT = true
  PORT_TO = ShipbreakerBay
end

class FlintsFinger < LandArea
  TITLE = 'Flint\'s Finger'
  CONNECTION_COUNT = 4
  CASTLE = true
end

class GreywaterWatch < LandArea
  TITLE = 'Greywater Watch'
  CONNECTION_COUNT = 5
  SUPPLY = 1
end

class Harrenhal < LandArea
  TITLE = 'Harrenhal'
  CONNECTION_COUNT = 4
  CASTLE = true
  POWER = 1
end

class Highgarden < LandArea
  TITLE = 'Highgarden'
  CONNECTION_COUNT = 6
  STRONGHOLD = true
  SUPPLY = 2
end

class Karhold < LandArea
  TITLE = 'Karhold'
  CONNECTION_COUNT = 3
  POWER = 1
end

class KingsLanding < LandArea
  TITLE = 'King\'s Landing'
  CONNECTION_COUNT = 5
  STRONGHOLD = true
  POWER = 2
end

class Kingswood < LandArea
  TITLE = 'Kingswood'
  CONNECTION_COUNT = 6
  SUPPLY = 1
  POWER = 1
end

class Lannisport < LandArea
  TITLE = 'Lannisport'
  CONNECTION_COUNT = 4
  STRONGHOLD = true
  SUPPLY = 2
  PORT = true
  PORT_TO = TheGoldenSound
end

class MoatCalin < LandArea
  TITLE = 'Moat Calin'
  CONNECTION_COUNT = 6
  CASTLE = true
end

class Oldtown < LandArea
  TITLE = 'Oldtown'
  CONNECTION_COUNT = 4
  STRONGHOLD = true
  PORT = true
  PORT_TO = RedwyneStraits
end

class PrincesPass < LandArea
  TITLE = 'Prince\'s Pass'
  CONNECTION_COUNT = 5
  SUPPLY = 1
  POWER = 1
end

class Pyke < LandArea
  TITLE = 'Pyke'
  CONNECTION_COUNT = 1
  STRONGHOLD = true
  SUPPLY = 1
  POWER = 1
  PORT = true
  PORT_TO = IronmansBay
end

class Riverrun < LandArea
  TITLE = 'Riverrun'
  CONNECTION_COUNT = 6
  STRONGHOLD = true
  SUPPLY = 1
  POWER = 1
end

class SaltShore < LandArea
  TITLE = 'Salt Shore'
  CONNECTION_COUNT = 4
  SUPPLY = 1
end

class Seagard < LandArea
  TITLE = 'Seagard'
  CONNECTION_COUNT = 5
  STRONGHOLD = true
  SUPPLY = 1
  POWER = 1
end

class SearoadMarches < LandArea
  TITLE = 'Searoad Marches'
  CONNECTION_COUNT = 8
  SUPPLY = 1
end

class Starfall < LandArea
  TITLE = 'Starfall'
  CONNECTION_COUNT = 5
  CASTLE = true
  SUPPLY = 1
end

class StoneySept < LandArea
  TITLE = 'Stoney Sept'
  CONNECTION_COUNT = 5
  POWER = 1
end

class StormsEnd < LandArea
  TITLE = 'Storm\'s End'
  CONNECTION_COUNT = 5
  CASTLE = true
  PORT = true
  PORT_TO = ShipbreakerBay
end

class Sunspear < LandArea
  TITLE = 'Sunspear'
  CONNECTION_COUNT = 4
  STRONGHOLD = true
  SUPPLY = 1
  POWER = 1
  PORT = true
  PORT_TO = EastSummerSea
end

class TheArbor < LandArea
  TITLE = 'The Arbor'
  CONNECTION_COUNT = 2
  POWER = 1
end

class TheBoneway < LandArea
  TITLE = 'The Boneway'
  CONNECTION_COUNT = 7
  POWER = 1
end

class TheEyrie < LandArea
  TITLE = 'The Eyrie'
  CONNECTION_COUNT = 2
  CASTLE = true
  SUPPLY = 1
  POWER = 1
end

class TheFingers < LandArea
  TITLE = 'The Fingers'
  CONNECTION_COUNT = 3
  SUPPLY = 1
end

class TheMountainsOfTheMoon < LandArea
  TITLE = 'The Mountains of the Moon'
  CONNECTION_COUNT = 5
  SUPPLY = 1
end

class TheReach < LandArea
  TITLE = 'The Reach'
  CONNECTION_COUNT = 7
  CASTLE = true
end

class TheStoneyShore < LandArea
  TITLE = 'The Stoney Shore'
  CONNECTION_COUNT = 2
  SUPPLY = 1
end

class TheTwins < LandArea
  TITLE = 'The Twins'
  CONNECTION_COUNT = 5
  POWER = 1
end

class ThreeTowers < LandArea
  TITLE = 'Three Towers'
  CONNECTION_COUNT = 5
  SUPPLY = 1
end

class WhiteHarbor < LandArea
  TITLE = 'White Harbor'
  CONNECTION_COUNT = 5
  CASTLE = true
  PORT = true
  PORT_TO = TheNarrowSea
end

class WidowsWatch < LandArea
  TITLE = 'Widow\'s Watch'
  CONNECTION_COUNT = 3
  SUPPLY = 1
end

class Winterfell < LandArea
  TITLE = 'Winterfell'
  CONNECTION_COUNT = 7
  STRONGHOLD = true
  SUPPLY = 1
  POWER = 1
  PORT = true
  PORT_TO = BayOfIce
end

class Yronwood < LandArea
  TITLE = 'Yronwood'
  CONNECTION_COUNT = 6
  CASTLE = true
end
