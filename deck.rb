class Deck
  STARTING_CARD_CLASSSES = []

  def initialize
    @deck = []
    self.class::STARTING_CARD_CLASSES.each do |card_class|
      @deck.push(card_class.new)
    end
  end
end

class PublicDeck < Deck
  attr_reader :deck
end

class HouseDeck < PublicDeck
  STARTING_CARD_CLASSES = [
    HouseStark,
    HouseLannister,
    HouseBaratheon,
    HouseGreyjoy,
    HouseTyrell,
    HouseMartell
  ]
end

class WesterosDeck < Deck
end

class WesterosDeckI < WesterosDeck
end

class WesterosDeckII < WesterosDeck
end

class WesterosDeckIII < WesterosDeck
end
