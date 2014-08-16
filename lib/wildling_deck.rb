class WildlingDeck < RandomDeck
  include ReplaceIntoDrawPileDeck

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
