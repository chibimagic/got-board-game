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
