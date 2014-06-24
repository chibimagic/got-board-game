class Area
  TITLE = ''
  STRONGHOLD = false
  CASTLE = false
  SUPPLY = 0
  POWER = 0
  PORT = false

  def to_s
    self.class::TITLE
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
end

class LandArea < Area
end

class SeaArea < Area
end

class Blackwater < LandArea
  TITLE = 'Blackwater'
  SUPPLY = 2
end

class CastleBlack < LandArea
  TITLE = 'Castle Black'
  POWER = 1
end

class CrackclawPoint < LandArea
  TITLE = 'Crackclaw Point'
  CASTLE = true
end

class DornishMarches < LandArea
  TITLE = 'Dornish Marches'
  POWER = 1
end

class Dragonstone < LandArea
  TITLE = 'Dragonstone'
  STRONGHOLD = true
  SUPPLY = 1
  POWER = 1
  PORT = true
end

class FlintsFinger < LandArea
  TITLE = 'Flint\'s Finger'
  CASTLE = true
end

class GreywaterWatch < LandArea
  TITLE = 'Greywater Watch'
  SUPPLY = 1
end

class Harrenhal < LandArea
  TITLE = 'Harrenhal'
  CASTLE = true
  POWER = 1
end

class Highgarden < LandArea
  TITLE = 'Highgarden'
  STRONGHOLD = true
  SUPPLY = 2
end

class Karhold < LandArea
  TITLE = 'Karhold'
  POWER = 1
end

class KingsLanding < LandArea
  TITLE = 'King\'s Landing'
  STRONGHOLD = true
  POWER = 2
end

class Kingswood < LandArea
  TITLE = 'Kingswood'
  SUPPLY = 1
  POWER = 1
end

class Lannisport < LandArea
  TITLE = 'Lannisport'
  STRONGHOLD = true
  SUPPLY = 2
  PORT = true
end

class MoatCalin < LandArea
  TITLE = 'Moat Calin'
  CASTLE = true
end

class Oldtown < LandArea
  TITLE = 'Oldtown'
  STRONGHOLD = true
  PORT = true
end

class PrincesPass < LandArea
  TITLE = 'Prince\'s Pass'
  SUPPLY = 1
  POWER = 1
end

class Pyke < LandArea
  TITLE = 'Pyke'
  STRONGHOLD = true
  SUPPLY = 1
  POWER = 1
  PORT = true
end

class Riverrun < LandArea
  TITLE = 'Riverrun'
  STRONGHOLD = true
  SUPPLY = 1
  POWER = 1
end

class SaltShore < LandArea
  TITLE = 'Salt Shore'
  SUPPLY = 1
end

class Seagard < LandArea
  TITLE = 'Seagard'
  STRONGHOLD = true
  SUPPLY = 1
  POWER = 1
end

class SearoadMarches < LandArea
  TITLE = 'Searoad Marches'
  SUPPLY = 1
end

class Starfall < LandArea
  TITLE = 'Starfell'
  CASTLE = true
  SUPPLY = 1
end

class StoneySept < LandArea
  TITLE = 'Stoney Sept'
  POWER = 1
end

class StormsEnd < LandArea
  TITLE = 'Storm\'s End'
  CASTLE = true
  PORT = true
end

class Sunspear < LandArea
  TITLE = 'Sunspear'
  STRONGHOLD = true
  SUPPLY = 1
  POWER = 1
  PORT = true
end

class TheArbor < LandArea
  TITLE = 'The Arbor'
  POWER = 1
end

class TheBoneway < LandArea
  TITLE = 'The Boneway'
  POWER = 1
end

class TheEyrie < LandArea
  TITLE = 'The Eyrie'
  CASTLE = true
  SUPPLY = 1
  POWER = 1
end

class TheFingers < LandArea
  TITLE = 'The Fingers'
  SUPPLY = 1
end

class TheMountainsOfTheMoon < LandArea
  TITLE = 'The Mountains of the Moon'
  SUPPLY = 1
end

class TheReach < LandArea
  TITLE = 'The Reach'
  CASTLE = true
end

class TheStoneyShore < LandArea
  TITLE = 'The Stoney Shore'
  SUPPLY = 1
end

class TheTwins < LandArea
  TITLE = 'The Twins'
  POWER = 1
end

class ThreeTowers < LandArea
  TITLE = 'Three Towers'
  SUPPLY = 1
end

class WhiteHarbor < LandArea
  TITLE = 'White Harbor'
  CASTLE = true
  PORT = true
end

class WidowsWatch < LandArea
  TITLE = 'Widow\'s Watch'
  SUPPLY = 1
end

class Winterfell < LandArea
  TITLE = 'Winterfell'
  STRONGHOLD = true
  SUPPLY = 1
  POWER = 1
  PORT = true
end

class Yronwood < LandArea
  TITLE = 'Yronwood'
  CASTLE = true
end

class BayOfIce < SeaArea
  TITLE = 'Bay of Ice'
end

class BlackwaterBay < SeaArea
  TITLE = 'Blackwater Bay'
end

class EastSummerSea < SeaArea
  TITLE = 'East Summer Sea'
end

class IronmansBay < SeaArea
  TITLE = 'Ironman\'s Bay'
end

class RedwyneStraits < SeaArea
  TITLE = 'Redwyne Straits'
end

class SeaOfDorne < SeaArea
  TITLE = 'Sea of Dorne'
end

class ShipbreakerBay < SeaArea
  TITLE = 'Shipbreaker Bay'
end

class SunsetSea < SeaArea
  TITLE = 'Sunset Sea'
end

class TheGoldenSound < SeaArea
  TITLE = 'The Golden Sound'
end

class TheNarrowSea < SeaArea
  TITLE = 'The Narrow Sea'
end

class TheShiveringSea < SeaArea
  TITLE = 'The Shivering Sea'
end

class WestSummerSea < SeaArea
  TITLE = 'West Summer Sea'
end
