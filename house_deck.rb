class HouseDeck < Deck
  include PublicDeck

  STARTING_CARD_CLASSES = [
    HouseStark,
    HouseLannister,
    HouseBaratheon,
    HouseGreyjoy,
    HouseTyrell,
    HouseMartell
  ]
end
