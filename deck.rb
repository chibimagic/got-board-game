require_relative 'house.rb'
require_relative 'house_card.rb'
require_relative 'wildling_card.rb'

class Deck
  STARTING_CARD_CLASSES = []

  def initialize
    @cards = []
    self.class::STARTING_CARD_CLASSES.each do |card_class|
      @cards.push(card_class.new)
    end
  end

  def cards_remaining
    @cards.length
  end
end

module PublicDeck
  def cards
    @cards
  end
end

module DrawFromTopDeck
  def draw_from_top
    @cards.shift
  end
end

module DropFromBottomDeck
  def draw_from_bottom
    @cards.pop
  end
end

module PlaceAtTopDeck
  def place_at_top(card)
    @cards.unshift(card)
  end
end

module PlaceAtBottomDeck
  def place_at_bottom(card)
    @cards.push(card)
  end
end

class RandomDeck < Deck
  def initialize
    super
    @cards.shuffle!
  end
end

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

class HouseCardDeck < Deck
  include PublicDeck
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

class WildlingDeck < RandomDeck
  include DrawFromTopDeck
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

class WesterosDeck < RandomDeck
end

class WesterosDeckI < WesterosDeck
end

class WesterosDeckII < WesterosDeck
end

class WesterosDeckIII < WesterosDeck
end
