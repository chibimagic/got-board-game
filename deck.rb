require_relative 'house.rb'
require_relative 'house_card.rb'

class Deck
  STARTING_CARD_CLASSES = []

  def initialize
    @cards = []
    self.class::STARTING_CARD_CLASSES.each do |card_class|
      @cards.push(card_class.new)
    end
  end
end

class PublicDeck < Deck
  attr_reader :cards
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

class HouseCardDeck < PublicDeck
end

class HouseStarkDeck < HouseCardDeck
  STARTING_CARD_CLASSES = [
    EddardStark,
    RobbStark,
    RooseBolton,
    GreatjonUmber,
    SerRodrickCassel,
    TheBlackfish,
    CatelynStark
  ]
end

class HouseLannisterDeck < HouseCardDeck
  STARTING_CARD_CLASSES = [
    TywinLannister,
    SerGregorClegane,
    TheHound,
    SerJaimeLannister,
    TyrionLannister,
    SerKevanLannister,
    CerseiLannister
  ]
end

class HouseBaratheonDeck < HouseCardDeck
  STARTING_CARD_CLASSES = [
    StannisBaratheon,
    RenlyBaratheon,
    SerDavosSeaworth,
    BrienneOfTarth,
    Melisandre,
    SalladhorSaan,
    Patchface
  ]
end

class HouseGreyjoyDeck < HouseCardDeck
  STARTING_CARD_CLASSES = [
    EuronCrowsEye,
    VictarionGreyjoy,
    TheonGreyjoy,
    BalonGreyjoy,
    AshaGreyjoy,
    DagmarCleftjaw,
    AeronDamphair
  ]
end

class HouseTyrellDeck < HouseCardDeck
  STARTING_CARD_CLASSES = [
    MaceTyrell,
    SerLorasTyrell,
    SerGarlanTyrell,
    RandyllTarly,
    AlesterFlorent,
    MargeryTyrell,
    QueenOfThorns
  ]
end

class HouseMartellDeck < HouseCardDeck
  STARTING_CARD_CLASSES = [
    TheRedViper,
    AreoHotah,
    ObaraSand,
    Darkstar,
    NymeriaSand,
    ArianneMartell,
    DoranMartell
  ]
end

class WildlingDeck < Deck
end

class WesterosDeck < Deck
end

class WesterosDeckI < WesterosDeck
end

class WesterosDeckII < WesterosDeck
end

class WesterosDeckIII < WesterosDeck
end
