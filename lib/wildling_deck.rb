class WildlingDeck < RandomDeck
  include PlaceAtTopDeck
  include PlaceAtBottomDeck

  STARTING_CARD_CLASSES = [
    AKingBeyondTheWall,
    CrowKillers,
    MammothRiders,
    MassingOnTheMilkwater,
    PreemptiveRaid,
    RattleshirtsRaiders,
    SilenceAtTheWall,
    SkinchangerScout,
    TheHordeDescends
  ]
end
