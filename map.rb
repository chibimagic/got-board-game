class Map
  attr_reader :locations

  LOCATIONS = [
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
  ]

  def initialize
    @locations = []
    LOCATIONS.each do |location_class|
      @locations.push(location_class.new)
    end
  end
end
