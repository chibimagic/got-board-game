class Area
  include ItemHolder

  TITLE = 'Area'
  CONNECTION_COUNT = 0
  STRONGHOLD = false
  CASTLE = false
  SUPPLY = 0
  POWER = 0

  def initialize(items)
    raise 'Invalid items' unless items.is_a?(Array) && items.all? { |item| item.is_a?(Token) }

    @items = items
  end

  def self.create_new
    items = []
    new(items)
  end

  def self.unserialize(data)
    items = data.map { |token_data| Token.unserialize(token_data) }
    new(items)
  end

  def serialize
    @items.map { |item| item.serialize }
  end

  def ==(o)
    self.class == o.class &&
      @items == o.items
  end

  def self.to_s
    self::TITLE
  end

  def to_s
    self.class::TITLE + ' (' + @items.count.to_s + ')'
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

  def controlling_house_class
    @items.empty? ? nil : @items[0].house_class
  end

  def enemy_controlled?(house_class)
    !controlling_house_class.nil? && controlling_house_class != house_class
  end

  def mustering_points
    if has_stronghold?
      2
    elsif has_castle?
      1
    else
      0
    end
  end

  def get_all(token_class)
    @items.find_all { |item| item.is_a?(token_class) }
  end

  # Mask ItemHolder.receive
  def receive(token)
    raise 'Call :receive! instead'
  end

  def receive!(token)
    if enemy_controlled?(token.house_class)
      raise 'Cannot place ' + token.to_s + ' because ' + to_s + ' is controlled by ' + controlling_house_class.to_s
    end

    if token.is_a?(OrderToken)
      if count(Unit) == 0
        raise 'Cannot place ' + token.to_s + ' because ' + to_s + ' has no units'
      elsif has?(OrderToken)
        raise 'Cannot place ' + token.to_s + ' because ' + to_s + ' already has an order token'
      end
    end

    ItemHolder.instance_method(:receive).bind(self).call(token)
  end
end

class SeaArea < Area
  def receive!(token)
    if [Footman, Knight, SiegeEngine].any? { |unit_class| token.is_a?(unit_class) }
      raise 'Cannot place ' + token.to_s + ' because ' + to_s + ' is a sea area'
    end

    super(token)
  end
end

class LandArea < Area
  def receive!(token)
    if token.is_a?(Ship)
      raise 'Cannot place ' + token.to_s + ' because ' + to_s + ' is a land area'
    end

    super(token)
  end
end

class PortArea < Area
  CONNECTION_COUNT = 2

  def receive!(token)
    if [Footman, Knight, SiegeEngine].any? { |unit_class| token.is_a?(unit_class) }
      raise 'Cannot place ' + token.to_s + ' because ' + to_s + ' is a port area'
    end

    if token.is_a?(Ship) && get_all(Ship).count === 3
      raise 'Cannot place more than 3 Ships in a port area'
    end

    super(token)
  end
end

class BayOfIce < SeaArea
  TITLE = 'Bay of Ice'
  CONNECTION_COUNT = 7
end

class BlackwaterBay < SeaArea
  TITLE = 'Blackwater Bay'
  CONNECTION_COUNT = 4
end

class EastSummerSea < SeaArea
  TITLE = 'East Summer Sea'
  CONNECTION_COUNT = 8
end

class IronmansBay < SeaArea
  TITLE = 'Ironman\'s Bay'
  CONNECTION_COUNT = 8
end

class RedwyneStraits < SeaArea
  TITLE = 'Redwyne Straits'
  CONNECTION_COUNT = 6
end

class SeaOfDorne < SeaArea
  TITLE = 'Sea of Dorne'
  CONNECTION_COUNT = 5
end

class ShipbreakerBay < SeaArea
  TITLE = 'Shipbreaker Bay'
  CONNECTION_COUNT = 9
end

class SunsetSea < SeaArea
  TITLE = 'Sunset Sea'
  CONNECTION_COUNT = 6
end

class TheGoldenSound < SeaArea
  TITLE = 'The Golden Sound'
  CONNECTION_COUNT = 6
end

class TheNarrowSea < SeaArea
  TITLE = 'The Narrow Sea'
  CONNECTION_COUNT = 11
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
  CONNECTION_COUNT = 2
  STRONGHOLD = true
  SUPPLY = 1
  POWER = 1
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
  CONNECTION_COUNT = 5
  STRONGHOLD = true
  SUPPLY = 2
end

class MoatCalin < LandArea
  TITLE = 'Moat Calin'
  CONNECTION_COUNT = 6
  CASTLE = true
end

class Oldtown < LandArea
  TITLE = 'Oldtown'
  CONNECTION_COUNT = 5
  STRONGHOLD = true
end

class PrincesPass < LandArea
  TITLE = 'Prince\'s Pass'
  CONNECTION_COUNT = 5
  SUPPLY = 1
  POWER = 1
end

class Pyke < LandArea
  TITLE = 'Pyke'
  CONNECTION_COUNT = 2
  STRONGHOLD = true
  SUPPLY = 1
  POWER = 1
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
  CONNECTION_COUNT = 6
  CASTLE = true
end

class Sunspear < LandArea
  TITLE = 'Sunspear'
  CONNECTION_COUNT = 5
  STRONGHOLD = true
  SUPPLY = 1
  POWER = 1
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
  CONNECTION_COUNT = 6
  CASTLE = true
end

class WidowsWatch < LandArea
  TITLE = 'Widow\'s Watch'
  CONNECTION_COUNT = 3
  SUPPLY = 1
end

class Winterfell < LandArea
  TITLE = 'Winterfell'
  CONNECTION_COUNT = 8
  STRONGHOLD = true
  SUPPLY = 1
  POWER = 1
end

class Yronwood < LandArea
  TITLE = 'Yronwood'
  CONNECTION_COUNT = 6
  CASTLE = true
end

class DragonstonePortToShipbreakerBay < PortArea
  TITLE = 'Dragonstone Port (Shipbreaker Bay)'
end

class LannisportPortToTheGoldenSound < PortArea
  TITLE = 'Lannisport Port (The Golden Sound)'
end

class OldtownPortToRedwyneStraits < PortArea
  TITLE = 'Oldtown Port (Redwyne Straits)'
end

class PykePortToIronmansBay < PortArea
  TITLE = 'Pyke Port (Ironmans Bay)'
end

class StormsEndPortToShipbreakerBay < PortArea
  TITLE = 'Storm\'s End Port (Shipbreaker Bay)'
end

class SunspearPortToEastSummerSea < PortArea
  TITLE = 'Sunspear Port (East Summer Sea)'
end

class WhiteHarborPortToTheNarrowSea < PortArea
  TITLE = 'White Harbor Port (The Narrow Sea)'
end

class WinterfellPortToBayOfIce < PortArea
  TITLE = 'Winterfell Port (Bay of Ice)'
end
