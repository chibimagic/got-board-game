class WesterosDeck < RandomDeck
  include PlaceAtTopDeck
  include PlaceAtBottomDeck
end

class WesterosDeckI < WesterosDeck
  STARTING_CARD_CLASSES = [
    Supply,
    Supply,
    Supply,
    Mustering,
    Mustering,
    Mustering,
    AThroneOfBlades,
    AThroneOfBlades,
    LastDaysOfSummer,
    WinterIsComing
  ]
end

class WesterosDeckII < WesterosDeck
  STARTING_CARD_CLASSES = [
    ClashOfKings,
    ClashOfKings,
    ClashOfKings,
    GameOfThrones,
    GameOfThrones,
    GameOfThrones,
    DarkWingsDarkWords,
    DarkWingsDarkWords,
    LastDaysOfSummer,
    WinterIsComing
  ]
end

class WesterosDeckIII < WesterosDeck
  STARTING_CARD_CLASSES = [
    WildlingsAttack,
    WildlingsAttack,
    WildlingsAttack,
    SeaOfStorms,
    RainsOfAutumn,
    FeastForCrows,
    WebOfLies,
    StormOfSwords,
    PutToTheSword,
    PutToTheSword
  ]
end
