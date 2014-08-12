class Map
  include Enumerable

  attr_reader :areas, :supply_track

  AREAS = [
    # Sea areas
    BayOfIce,
    BlackwaterBay,
    EastSummerSea,
    IronmansBay,
    RedwyneStraits,
    SeaOfDorne,
    ShipbreakerBay,
    SunsetSea,
    TheGoldenSound,
    TheNarrowSea,
    TheShiveringSea,
    WestSummerSea,
    # Land areas
    Blackwater,
    CastleBlack,
    CrackclawPoint,
    DornishMarches,
    Dragonstone,
    FlintsFinger,
    GreywaterWatch,
    Harrenhal,
    Highgarden,
    Karhold,
    KingsLanding,
    Kingswood,
    Lannisport,
    MoatCalin,
    Oldtown,
    PrincesPass,
    Pyke,
    Riverrun,
    SaltShore,
    Seagard,
    SearoadMarches,
    Starfall,
    StoneySept,
    StormsEnd,
    Sunspear,
    TheArbor,
    TheBoneway,
    TheEyrie,
    TheFingers,
    TheMountainsOfTheMoon,
    TheReach,
    TheStoneyShore,
    TheTwins,
    ThreeTowers,
    WhiteHarbor,
    WidowsWatch,
    Winterfell,
    Yronwood,
    # Ports
    DragonstonePortToShipbreakerBay,
    LannisportPortToTheGoldenSound,
    OldtownPortToRedwyneStraits,
    PykePortToIronmansBay,
    StormsEndPortToShipbreakerBay,
    SunspearPortToEastSummerSea,
    WhiteHarborPortToTheNarrowSea,
    WinterfellPortToBayOfIce,
  ]

  CONNECTIONS = [
    # Land to land
    [Blackwater, CrackclawPoint],
    [Blackwater, Harrenhal],
    [Blackwater, KingsLanding],
    [Blackwater, SearoadMarches],
    [Blackwater, StoneySept],
    [Blackwater, TheReach],
    [CastleBlack, Karhold],
    [CastleBlack, Winterfell],
    [CrackclawPoint, Harrenhal],
    [CrackclawPoint, KingsLanding],
    [CrackclawPoint, TheMountainsOfTheMoon],
    [DornishMarches, Highgarden],
    [DornishMarches, Oldtown],
    [DornishMarches, PrincesPass],
    [DornishMarches, TheBoneway],
    [DornishMarches, TheReach],
    [DornishMarches, ThreeTowers],
    [FlintsFinger, GreywaterWatch],
    [GreywaterWatch, MoatCalin],
    [GreywaterWatch, Seagard],
    [Harrenhal, Riverrun],
    [Harrenhal, StoneySept],
    [Highgarden, Oldtown],
    [Highgarden, SearoadMarches],
    [Highgarden, TheReach],
    [Karhold, Winterfell],
    [KingsLanding, Kingswood],
    [KingsLanding, TheReach],
    [Kingswood, StormsEnd],
    [Kingswood, TheBoneway],
    [Kingswood, TheReach],
    [Lannisport, Riverrun],
    [Lannisport, SearoadMarches],
    [Lannisport, StoneySept,],
    [MoatCalin, Seagard],
    [MoatCalin, TheTwins],
    [MoatCalin, WhiteHarbor],
    [MoatCalin, Winterfell],
    [Oldtown, ThreeTowers],
    [PrincesPass, Starfall],
    [PrincesPass, TheBoneway],
    [PrincesPass, ThreeTowers],
    [PrincesPass, Yronwood],
    [Riverrun, Seagard],
    [Riverrun, StoneySept],
    [SaltShore, Starfall],
    [SaltShore, Sunspear],
    [SaltShore, Yronwood],
    [Seagard, TheTwins],
    [SearoadMarches, StoneySept],
    [SearoadMarches, TheReach],
    [Starfall, Yronwood],
    [StormsEnd, TheBoneway],
    [Sunspear, Yronwood],
    [TheBoneway, TheReach],
    [TheBoneway, Yronwood],
    [TheEyrie, TheMountainsOfTheMoon],
    [TheFingers, TheMountainsOfTheMoon],
    [TheFingers, TheTwins],
    [TheMountainsOfTheMoon, TheTwins],
    [TheStoneyShore, Winterfell],
    [WhiteHarbor, WidowsWatch],
    [WhiteHarbor, Winterfell],
    # Land to sea
    [CastleBlack, BayOfIce],
    [CastleBlack, TheShiveringSea],
    [CrackclawPoint, BlackwaterBay],
    [CrackclawPoint, ShipbreakerBay],
    [CrackclawPoint, TheNarrowSea],
    [Dragonstone, ShipbreakerBay],
    [FlintsFinger, BayOfIce],
    [FlintsFinger, IronmansBay],
    [FlintsFinger, SunsetSea],
    [GreywaterWatch, BayOfIce],
    [GreywaterWatch, IronmansBay],
    [Highgarden, RedwyneStraits],
    [Highgarden, WestSummerSea],
    [Karhold, TheShiveringSea],
    [KingsLanding, BlackwaterBay],
    [Kingswood, BlackwaterBay],
    [Kingswood, ShipbreakerBay],
    [Lannisport, TheGoldenSound],
    [MoatCalin, TheNarrowSea],
    [Oldtown, RedwyneStraits],
    [Pyke, IronmansBay],
    [Riverrun, IronmansBay],
    [Riverrun, TheGoldenSound],
    [SaltShore, EastSummerSea],
    [Seagard, IronmansBay],
    [SearoadMarches, SunsetSea],
    [SearoadMarches, TheGoldenSound],
    [SearoadMarches, WestSummerSea],
    [Starfall, EastSummerSea],
    [Starfall, WestSummerSea],
    [StormsEnd, EastSummerSea],
    [StormsEnd, SeaOfDorne],
    [StormsEnd, ShipbreakerBay],
    [Sunspear, EastSummerSea],
    [Sunspear, SeaOfDorne],
    [TheArbor, RedwyneStraits],
    [TheArbor, WestSummerSea],
    [TheBoneway, SeaOfDorne],
    [TheEyrie, TheNarrowSea],
    [TheFingers, TheNarrowSea],
    [TheMountainsOfTheMoon, TheNarrowSea],
    [TheStoneyShore, BayOfIce],
    [TheTwins, TheNarrowSea],
    [ThreeTowers, RedwyneStraits],
    [ThreeTowers, WestSummerSea],
    [WhiteHarbor, TheNarrowSea],
    [WhiteHarbor, TheShiveringSea],
    [WidowsWatch, TheNarrowSea],
    [WidowsWatch, TheShiveringSea],
    [Winterfell, BayOfIce],
    [Winterfell, TheShiveringSea],
    [Yronwood, SeaOfDorne],
    # Sea to sea
    [BayOfIce, SunsetSea],
    [BlackwaterBay, ShipbreakerBay],
    [EastSummerSea, SeaOfDorne],
    [EastSummerSea, ShipbreakerBay],
    [EastSummerSea, WestSummerSea],
    [IronmansBay, SunsetSea],
    [IronmansBay, TheGoldenSound],
    [RedwyneStraits, WestSummerSea],
    [ShipbreakerBay, TheNarrowSea],
    [SunsetSea, TheGoldenSound],
    [SunsetSea, WestSummerSea],
    [TheNarrowSea, TheShiveringSea],
    # Port to land
    [DragonstonePortToShipbreakerBay, Dragonstone],
    [LannisportPortToTheGoldenSound, Lannisport],
    [OldtownPortToRedwyneStraits, Oldtown],
    [PykePortToIronmansBay, Pyke],
    [StormsEndPortToShipbreakerBay, StormsEnd],
    [SunspearPortToEastSummerSea, Sunspear],
    [WhiteHarborPortToTheNarrowSea, WhiteHarbor],
    [WinterfellPortToBayOfIce, Winterfell],
    # Port to sea
    [DragonstonePortToShipbreakerBay, ShipbreakerBay],
    [LannisportPortToTheGoldenSound, TheGoldenSound],
    [OldtownPortToRedwyneStraits, RedwyneStraits],
    [PykePortToIronmansBay, IronmansBay],
    [StormsEndPortToShipbreakerBay, ShipbreakerBay],
    [SunspearPortToEastSummerSea, EastSummerSea],
    [WhiteHarborPortToTheNarrowSea, TheNarrowSea],
    [WinterfellPortToBayOfIce, BayOfIce],
  ]

  ARMIES_ALLOWED = {
    0 => [2, 2],
    1 => [3, 2],
    2 => [3, 2, 2],
    3 => [3, 2, 2, 2],
    4 => [3, 3, 2, 2],
    5 => [4, 3, 2, 2],
    6 => [4, 3, 2, 2, 2]
  }

  def initialize(areas, supply_track)
    raise 'Invalid areas' unless areas.is_a?(Array) && areas.all? { |area| area.is_a?(Area) }
    raise 'Invalid supply track' unless supply_track.is_a?(Hash) && supply_track.keys == (0..6).to_a && supply_track.values.all? { |v| v.is_a?(Array) && v.all? { |house_class| house_class.class == Class && house_class < House } }

    @areas = areas
    @supply_track = supply_track
  end

  def self.create_new(houses = [])
    areas = []
    AREAS.each do |area_class|
      areas.push(area_class.create_new)
    end

    NeutralForceTokens.get_tokens(houses.count).each do |token|
      areas.find { |area| area.class == token.area_class }.receive_token!(token)
    end

    supply_track = {
      0 => [],
      1 => [],
      2 => [],
      3 => [],
      4 => [],
      5 => [],
      6 => [],
    }
    houses.each do |house|
      house.class::STARTING_UNITS.each do |area_class, starting_unit_classes|
        starting_unit_classes.each do |starting_unit_class|
          unit = house.remove_token!(starting_unit_class)
          areas.find { |area| area.class == area_class }.receive_token!(unit)
        end
      end
      areas.find { |area| area.class == house.class::HOME_AREA }.receive_token!(GarrisonToken.new(house.class))
      supply_track_position = house.class::INITIAL_SUPPLY
      supply_track[supply_track_position].push(house.class)
    end

    new(areas, supply_track)
  end

  def self.unserialize(data)
    areas = data['areas'].map { |area_class_string, area_data| area_class_string.constantize.unserialize(area_data) }
    supply_track = data['supply_track'].map { |supply_level, house_class_strings| [supply_level.to_i, house_class_strings.map { |house_class_string| house_class_string.constantize }] }.to_h
    new(areas, supply_track)
  end

  def serialize
    areas = @areas.map { |area| [area.class.name, area.serialize] }.to_h
    supply_track = @supply_track.map { |supply_level, house_classes| [supply_level, house_classes.map { |house_class| house_class.name }] }.to_h
    {
      :areas => areas,
      :supply_track => supply_track
    }
  end

  def ==(o)
    self.class == o.class &&
      @areas == o.areas &&
      @supply_track == o.supply_track
  end

  # Fulfill Enumerable
  def each(&block)
    @areas.each(&block)
  end

  def area(area_class)
    area = @areas.find { |area| area.class == area_class }

    if area.nil?
      raise 'Invalid area ' + area_class.to_s
    else
      area
    end
  end

  def connections
    self.class::CONNECTIONS
  end

  def connected?(area_class1, area_class2)
    connections.include?([area_class1, area_class2]) || connections.include?([area_class2, area_class1])
  end

  def connected_via_ship_transport?(house_class, area_class1, area_class2)
    unless area_class1 < LandArea && area_class2 < LandArea
      return false
    end

    controlled_sea_classes = controlled_areas(house_class).find_all { |area| area.is_a?(SeaArea) }.map { |area| area.class }

    transport_sea_classes = connected_sea_classes(area_class1) & controlled_sea_classes
    transport_sea_classes.each do |transport_sea_class|
      new_connected_seas = connected_sea_classes(transport_sea_class) & controlled_sea_classes - transport_sea_classes
      transport_sea_classes.concat(new_connected_seas)
    end

    connected_land_classes = transport_sea_classes.map { |sea_class| connected_land_classes(sea_class) }.flatten.uniq
    connected_land_classes.include?(area_class2)
  end

  def connected_area_classes(area_class)
    connections.find_all { |connection| connection.include?(area_class) }.map { |connection| connection - [area_class] }.flatten
  end

  def connected_land_classes(area_class)
    connected_area_classes(area_class).find_all { |area_class| area_class < LandArea }
  end

  def connected_sea_classes(area_class)
    connected_area_classes(area_class).find_all { |area_class| area_class < SeaArea }
  end

  def controlled_areas(house_class)
    @areas.find_all { |area| area.controlling_house_class == house_class }
  end

  def armies(house_class)
    controlled_areas(house_class).map { |area| area.count_tokens(Unit) }.reject { |count| count < 2 }.sort.reverse
  end

  def special_orders_placed(house_class)
    controlled_areas(house_class).count { |area| area.has_token?(OrderToken) && area.get_tokens(OrderToken).first.special }
  end

  def has_order?(order_class, house_class)
    @areas.any? { |area| area.has_token?(order_class) && area.controlling_house_class == house_class }
  end

  def musterable_areas(house_class)
    controlled_areas(house_class).map { |area| [area.class, area.mustering_points] }.to_h
  end

  def recalculate_supply(house_class)
    controlled_areas(house_class).inject(0) { |sum, area| sum + area.supply }
  end

  def supply_level(house_class)
    supply_track.select { |supply_level, house_classes| house_classes.include?(house_class) }.keys.first
  end

  def houses(supply_level)
    supply_track.fetch(supply_level, [])
  end

  def set_level(house_class, new_supply_level)
    supply_track.each_value { |v| v.delete(house_class) }
    supply_track.fetch(new_supply_level).push(house_class)
  end

  def armies_allowed(house_class)
    ARMIES_ALLOWED.fetch(supply_level(house_class))
  end

  def conforms_to_supply_limits?(house_class)
    actual = armies(house_class)
    allowed = armies_allowed(house_class)
    actual.each_with_index do |army_size, index|
      return false if allowed[index].nil? || army_size > allowed[index]
    end
    true
  end

  def strongholds_controlled(house_class)
    controlled_areas(house_class).count { |area| area.has_stronghold? }
  end

  def victory_points(house_class)
    controlled_areas(house_class).count { |area| area.has_castle? || area.has_stronghold? }
  end

  def houses_with_victory_points(points)
    Game::HOUSE_CLASSES.find_all { |house_class| victory_points(house_class) == points }
  end
end
