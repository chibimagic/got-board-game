class Map
  include Enumerable

  attr_reader :areas

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
    WinterfellPortToBayOIce,
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
  ]

  def initialize(areas)
    raise 'Invalid areas' unless areas.is_a?(Array) && areas.all? { |area| area.is_a?(Area) }

    @areas = areas
  end

  def self.create_new(houses = [])
    areas = []
    AREAS.each do |area_class|
      areas.push(area_class.create_new)
    end

    NeutralForceTokens.get_tokens(houses.count).each do |token|
      areas.find { |area| area.class == token.area_class }.receive_token!(token)
    end

    houses.each do |house|
      house.class::STARTING_UNITS.each do |area_class, starting_unit_classes|
        starting_unit_classes.each do |starting_unit_class|
          unit = house.remove_token!(starting_unit_class)
          areas.find { |area| area.class == area_class }.receive_token!(unit)
        end
      end
      areas.find { |area| area.class == house.class::HOME_AREA }.receive_token!(GarrisonToken.new(house.class))
    end
    new(areas)
  end

  def self.unserialize(data)
    areas = data.map { |area_class_string, area_data| area_class_string.constantize.unserialize(area_data) }
    new(areas)
  end

  def serialize
    Hash[@areas.map { |area| [area.class.name, area.serialize] }]
  end

  def ==(o)
    self.class == o.class &&
      @areas == o.areas
  end

  # Fulfill Enumerable
  def each(&block)
    @areas.each(&block)
  end

  def area(area_class)
    @areas.find { |area| area.class == area_class }
  end

  def connections
    self.class::CONNECTIONS
  end

  def connected?(area_class1, area_class2)
    connections.include?([area_class1, area_class2]) || connections.include?([area_class2, area_class1])
  end

  def connected_areas(area_class)
    connections.find_all { |connection| connection.include?(area_class) }.map { |connection| connection - [area_class] }.flatten
  end

  def connected_lands(area_class)
    connected_areas(area_class).find_all { |area_class| area_class < LandArea }
  end

  def connected_seas(area_class)
    connected_areas(area_class).find_all { |area_class| area_class < SeaArea }
  end

  def controlled_areas(house_class)
    @areas.find_all { |area| area.controlling_house == house_class }
  end

  def armies(house_class)
    controlled_areas(house_class).map { |area| area.count_tokens(Unit) }.reject { |count| count < 2 }.sort.reverse
  end

  def special_orders_placed(house_class)
    controlled_areas(house_class).count { |area| area.has_token?(OrderToken) && area.get_tokens(OrderToken).first.special }
  end

  def orders
    areas_with_orders = @areas.find_all { |area| area.has_token?(OrderToken) }
    Hash[areas_with_orders.map { |area| [area.class, area.get_tokens(OrderToken).first.class] }]
  end

  def orders_in?
    @areas.find { |area| area.has_token?(Unit) && !area.has_token?(OrderToken) } ? false : true
  end

  def recalculate_supply(house_class)
    controlled_areas(house_class).inject(0) { |sum, area| sum + area.supply }
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
