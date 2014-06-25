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
    [Blackwater, CrackclawPoint].to_set,
    [Blackwater, Harrenhal].to_set,
    [Blackwater, KingsLanding].to_set,
    [Blackwater, SearoadMarches].to_set,
    [Blackwater, StoneySept].to_set,
    [Blackwater, TheReach].to_set,
    [CastleBlack, Karhold].to_set,
    [CastleBlack, Winterfell].to_set,
    [CrackclawPoint, Harrenhal].to_set,
    [CrackclawPoint, KingsLanding].to_set,
    [CrackclawPoint, TheMountainsOfTheMoon].to_set,
    [DornishMarches, Highgarden].to_set,
    [DornishMarches, Oldtown].to_set,
    [DornishMarches, PrincesPass].to_set,
    [DornishMarches, TheBoneway].to_set,
    [DornishMarches, TheReach].to_set,
    [DornishMarches, ThreeTowers].to_set,
    [FlintsFinger, GreywaterWatch].to_set,
    [GreywaterWatch, MoatCalin].to_set,
    [GreywaterWatch, Seagard].to_set,
    [Harrenhal, Riverrun].to_set,
    [Harrenhal, StoneySept].to_set,
    [Highgarden, Oldtown].to_set,
    [Highgarden, SearoadMarches].to_set,
    [Highgarden, TheReach].to_set,
    [Karhold, Winterfell].to_set,
    [KingsLanding, Kingswood].to_set,
    [KingsLanding, TheReach].to_set,
    [Kingswood, StormsEnd].to_set,
    [Kingswood, TheBoneway].to_set,
    [Kingswood, TheReach].to_set,
    [Lannisport, Riverrun].to_set,
    [Lannisport, SearoadMarches].to_set,
    [Lannisport, StoneySept,].to_set,
    [MoatCalin, Seagard].to_set,
    [MoatCalin, TheTwins].to_set,
    [MoatCalin, WhiteHarbor].to_set,
    [MoatCalin, Winterfell].to_set,
    [Oldtown, ThreeTowers].to_set,
    [PrincesPass, Starfall].to_set,
    [PrincesPass, TheBoneway].to_set,
    [PrincesPass, ThreeTowers].to_set,
    [PrincesPass, Yronwood].to_set,
    [Riverrun, Seagard].to_set,
    [Riverrun, StoneySept].to_set,
    [SaltShore, Starfall].to_set,
    [SaltShore, Sunspear].to_set,
    [SaltShore, Yronwood].to_set,
    [Seagard, TheTwins].to_set,
    [SearoadMarches, StoneySept].to_set,
    [SearoadMarches, TheReach].to_set,
    [Starfall, Yronwood].to_set,
    [StormsEnd, TheBoneway].to_set,
    [Sunspear, Yronwood].to_set,
    [TheBoneway, TheReach].to_set,
    [TheBoneway, Yronwood].to_set,
    [TheEyrie, TheMountainsOfTheMoon].to_set,
    [TheFingers, TheMountainsOfTheMoon].to_set,
    [TheFingers, TheTwins].to_set,
    [TheMountainsOfTheMoon, TheTwins].to_set,
    [TheStoneyShore, Winterfell].to_set,
    [WhiteHarbor, WidowsWatch].to_set,
    [WhiteHarbor, Winterfell].to_set,
    # Land to sea
    [CastleBlack, BayOfIce].to_set,
    [CastleBlack, TheShiveringSea].to_set,
    [CrackclawPoint, BlackwaterBay].to_set,
    [CrackclawPoint, ShipbreakerBay].to_set,
    [CrackclawPoint, TheNarrowSea].to_set,
    [Dragonstone, ShipbreakerBay].to_set,
    [FlintsFinger, BayOfIce].to_set,
    [FlintsFinger, IronmansBay].to_set,
    [FlintsFinger, SunsetSea].to_set,
    [GreywaterWatch, BayOfIce].to_set,
    [GreywaterWatch, IronmansBay].to_set,
    [Highgarden, RedwyneStraits].to_set,
    [Highgarden, WestSummerSea].to_set,
    [Karhold, TheShiveringSea].to_set,
    [KingsLanding, BlackwaterBay].to_set,
    [Kingswood, BlackwaterBay].to_set,
    [Kingswood, ShipbreakerBay].to_set,
    [Lannisport, TheGoldenSound].to_set,
    [MoatCalin, TheNarrowSea].to_set,
    [Oldtown, RedwyneStraits].to_set,
    [Pyke, IronmansBay].to_set,
    [Riverrun, IronmansBay].to_set,
    [Riverrun, TheGoldenSound].to_set,
    [SaltShore, EastSummerSea].to_set,
    [Seagard, IronmansBay].to_set,
    [SearoadMarches, SunsetSea].to_set,
    [SearoadMarches, TheGoldenSound].to_set,
    [SearoadMarches, WestSummerSea].to_set,
    [Starfall, EastSummerSea].to_set,
    [Starfall, WestSummerSea].to_set,
    [StormsEnd, EastSummerSea].to_set,
    [StormsEnd, SeaOfDorne].to_set,
    [StormsEnd, ShipbreakerBay].to_set,
    [Sunspear, EastSummerSea].to_set,
    [Sunspear, SeaOfDorne].to_set,
    [TheArbor, RedwyneStraits].to_set,
    [TheArbor, WestSummerSea].to_set,
    [TheBoneway, SeaOfDorne].to_set,
    [TheEyrie, TheNarrowSea].to_set,
    [TheFingers, TheNarrowSea].to_set,
    [TheMountainsOfTheMoon, TheNarrowSea].to_set,
    [TheStoneyShore, BayOfIce].to_set,
    [TheTwins, TheNarrowSea].to_set,
    [ThreeTowers, RedwyneStraits].to_set,
    [ThreeTowers, WestSummerSea].to_set,
    [WhiteHarbor, TheNarrowSea].to_set,
    [WhiteHarbor, TheShiveringSea].to_set,
    [WidowsWatch, TheNarrowSea].to_set,
    [WidowsWatch, TheShiveringSea].to_set,
    [Winterfell, BayOfIce].to_set,
    [Winterfell, TheShiveringSea].to_set,
    [Yronwood, SeaOfDorne].to_set,
    # Sea to sea
    [BayOfIce, SunsetSea].to_set,
    [BlackwaterBay, ShipbreakerBay].to_set,
    [EastSummerSea, SeaOfDorne].to_set,
    [EastSummerSea, ShipbreakerBay].to_set,
    [EastSummerSea, WestSummerSea].to_set,
    [IronmansBay, SunsetSea].to_set,
    [IronmansBay, TheGoldenSound].to_set,
    [RedwyneStraits, WestSummerSea].to_set,
    [ShipbreakerBay, TheNarrowSea].to_set,
    [SunsetSea, TheGoldenSound].to_set,
    [SunsetSea, WestSummerSea].to_set,
    [TheNarrowSea, TheShiveringSea].to_set,
  ].to_set

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

  def connections
    self.class::CONNECTIONS
  end

  def connected?(area1, area2)
    connections.include?([area1, area2].to_set)
  end

  def connected_areas(area)
    connections.find_all { |connection| connection.include?(area) }.map { |connection| connection - [area] }.to_set.flatten
  end

  def connected_lands(area)
    connected_areas(area).find_all { |area| area < LandArea }.to_set
  end

  def connected_seas(area)
    connected_areas(area).find_all { |area| area < SeaArea }.to_set
  end

  def controlled_areas(house_class)
    @areas.find_all { |area| area.controlling_house == house_class }
  end

  def supply_level(house_class)
    controlled_areas(house_class).inject(0) { |sum, area| sum + area.supply }
  end

  def houses_with_supply(supply)
    Houses.new.find_all { |house| supply_level(house) == supply }.to_set
  end
end
