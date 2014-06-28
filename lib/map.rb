class Map
  attr_reader :areas

  AREAS = [
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
    Yronwood
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

  ARMIES_ALLOWED = {
    0 => [2, 2],
    1 => [3, 2],
    2 => [3, 2, 2],
    3 => [3, 2, 2, 2],
    4 => [3, 3, 2, 2],
    5 => [4, 3, 2, 2],
    6 => [4, 3, 2, 2, 2]
  }

  def initialize
    @areas = []
    AREAS.each do |area_class|
      @areas.push(area_class.new)
    end
  end

  def area(area_class)
    @areas.find { |area| area.class == area_class }
  end
  private :area

  def connections
    self.class::CONNECTIONS
  end

  def connected?(area1, area2)
    connections.include?([area1, area2]) || connections.include?([area2, area1])
  end

  def connected_areas(area)
    connections.find_all { |connection| connection.include?(area) }.map { |connection| connection - [area] }.flatten
  end

  def connected_lands(area)
    connected_areas(area).find_all { |area| area < LandArea }
  end

  def connected_seas(area)
    connected_areas(area).find_all { |area| area < SeaArea }
  end

  def controlled_areas(house_class)
    @areas.find_all { |area| area.controlling_house == house_class }
  end

  def place_token(area_class, token)
    area(area_class).place_token(token)
  end

  def armies(house_class)
    controlled_areas(house_class).map { |area| area.unit_count }.reject { |unit_count| unit_count < 2 }.sort.reverse
  end

  def supply_level(house_class)
    controlled_areas(house_class).inject(0) { |sum, area| sum + area.supply }
  end

  def houses_with_supply(supply)
    Houses.new.find_all { |house| supply_level(house) == supply }
  end
end
