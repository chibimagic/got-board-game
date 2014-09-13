class House
end
class HouseStark < House
end
class HouseLannister < House
end
class HouseBaratheon < House
end
class HouseGreyjoy < House
end
class HouseTyrell < House
end
class HouseMartell < House
end

class HouseCard < Card
  TITLE = ''
  COMBAT_STRENGTH = 0
  SWORDS = 0
  FORTIFICATIONS = 0
  TEXT = ''

  def house_class
    self.class::HOUSE
  end

  def to_s
    self.class::TITLE
  end

  def title
    self.class::TITLE
  end

  def combat_strength
    self.class::COMBAT_STRENGTH
  end

  def swords
    self.class::SWORDS
  end

  def fortifications
    self.class::FORTIFICATIONS
  end

  def text
    self.class::TEXT
  end
end

class HouseStarkCard < HouseCard
  HOUSE = HouseStark
end

class EddardStark < HouseStarkCard
  TITLE = 'Eddard Stark'
  COMBAT_STRENGTH = 4
  SWORDS = 2
end

class RobbStark < HouseStarkCard
  TITLE = 'Robb Stark'
  COMBAT_STRENGTH = 3
  TEXT = 'If you win this combat, you may choose the area to which your opponent retreats. You must choose a legal rea where your opponent loses the fewest units.'
end

class RooseBolton < HouseStarkCard
  TITLE = 'RooseBolton'
  COMBAT_STRENGTH = 2
  TEXT = 'If you lose this combat, return your entire House card discard pile into your hand (including this card)'
end

class GreatjonUmber < HouseStarkCard
  TITLE = 'Greatjon Umber'
  COMBAT_STRENGTH = 2
  SWORDS = 2
end

class SerRodrickCassel < HouseStarkCard
  TITLE = 'Ser Rodrick Cassel'
  COMBAT_STRENGTH = 1
  FORTIFICATIONS = 2
end

class TheBlackfish < HouseStarkCard
  TITLE = 'The Blackfish'
  COMBAT_STRENGTH = 1
  TEXT = 'You do not take casualties in this combat from House card abilities, Combat icons, or Tides of Battle cards.'
end

class CatelynStark < HouseStarkCard
  TITLE = 'Catelyn Stark'
  TEXT = 'If you have a Defence Order token in the embattled area, its value is doubled.'
end

class HouseLannisterCard < HouseCard
  HOUSE = HouseLannister
end

class TywinLannister < HouseLannisterCard
  TITLE = 'Tywin Lannister'
  COMBAT_STRENGTH = 4
  TEXT = 'If you win this combat, gain two Power tokens.'
end

class SerGregorClegane < HouseLannisterCard
  TITLE = 'Ser Gregot Clegane'
  COMBAT_STRENGTH = 3
  SWORDS = 3
end

class TheHound < HouseLannisterCard
  TITLE = 'The Hound'
  COMBAT_STRENGTH = 2
  FORTIFICATIONS = 2
end

class SerJaimeLannister < HouseLannisterCard
  TITLE = 'Ser Jaime Lannister'
  COMBAT_STRENGTH = 2
  SWORDS = 1
end

class TyrionLannister < HouseLannisterCard
  TITLE = 'Tyrion Lannister'
  COMBAT_STRENGTH = 1
  TEXT = 'You may immediately cancel your opponent\'s House card and return it to his hand. He must then choose a different House card to reveal. If he has no other House cards in hand, he cannot use a House card this combat.'
end

class SerKevanLannister < HouseLannisterCard
  TITLE = 'Ser Kevan Lannister'
  COMBAT_STRENGTH = 1
  TEXT = 'If you are attacking, all of your participating Footmen (including supporting Lannister footmen) add +2 combat strength instead of +1'
end

class CerseiLannister < HouseLannisterCard
  TITLE = 'Cersei Lannister'
  TEXT = 'If you win this combat, you may remove one of the losing opponent\'s Order tokens from anywhere on the board.'
end

class HouseBaratheonCard < HouseCard
  HOUSE = HouseBaratheon
end

class StannisBaratheon < HouseBaratheonCard
  TITLE = 'Stannis Baratheon'
  COMBAT_STRENGTH = 4
  TEXT = 'If your opponent has a higher position on the Iron Throne Influence track than you, this card gains +1 combat strength.'
end

class RenlyBaratheon < HouseBaratheonCard
  TITLE = 'Renly Baratheon'
  COMBAT_STRENGTH = 3
  TEXT = 'If you win this combat, you may upgrade on of your participating Footment (or one supporting Baratheon Footman) to a Knight.'
end

class SerDavosSeaworth < HouseBaratheonCard
  TITLE = 'Ser Davos Seaworth'
  COMBAT_STRENGTH = 2
  TEXT = 'If "Stannis Baratheon" is in your discard pile, this card gains +1 combat strength and a sword icon.'
end

class BrienneOfTarth < HouseBaratheonCard
  TITLE = 'Brienne of Tarth'
  COMBAT_STRENGTH = 2
  SWORDS = 1
  FORTIFICATIONS = 1
end

class Melisandre < HouseBaratheonCard
  TITLE = 'Melisandre'
  COMBAT_STRENGTH = 1
  SWORDS = 1
end

class SalladhorSaan < HouseBaratheonCard
  TITLE = 'Salladhor Saan'
  COMBAT_STRENGTH = 1
  TEXT = 'If you are being supported in this combat, the combat strength of all non-Baratheon Ships is reduced to 0.'
end

class Patchface < HouseBaratheonCard
  TITLE = 'Patchface'
  TEXT = 'After combat, you may look at your opponent\'s hand and discard one card of your choice.'
end

class HouseGreyjoyCard < HouseCard
  HOUSE = HouseGreyjoy
end

class EuronCrowsEye < HouseGreyjoyCard
  TITLE = 'Euron Crow\'s Eye'
  COMBAT_STRENGTH = 4
  SWORDS = 1
end

class VictarionGreyjoy < HouseGreyjoyCard
  TITLE = 'Victarion Greyjoy'
  COMBAT_STRENGTH = 3
  TEXT = 'If you are attacking, all of your participating Ships (incl. supporting Greyjoy Ships) add +2 to combat strength instead of +1.'
end

class TheonGreyjoy < HouseGreyjoyCard
  TITLE = 'Theon Greyjoy'
  COMBAT_STRENGTH = 2
  TEXT = 'If you are defending an area that contains either a Stronghold or a Castle, this card gains +1 combat strength, and a sword icon.'
end

class BalonGreyjoy < HouseGreyjoyCard
  TITLE = 'Balon Greyjoy'
  COMBAT_STRENGTH = 2
  TEXT = 'The printed combat strength of your opponent\'s House card is reduced to 0.'
end

class AshaGreyjoy < HouseGreyjoyCard
  TITLE = 'Asha Greyjoy'
  COMBAT_STRENGTH = 1
  TEXT = 'If you are not being supported in this combat, this card gains two sword icons and one fortification icon.'
end

class DagmarCleftjaw < HouseGreyjoyCard
  TITLE = 'Dagmar Cleftjaw'
  COMBAT_STRENGTH = 1
  SWORDS = 1
  FORTIFICATIONS = 1
end

class AeronDamphair < HouseGreyjoyCard
  TITLE = 'Aeron Damphair'
  TEXT = 'You may immediately discard two of your available Power tokens to discard Aeron Damphair and choose a different House Card from your hand (if able).'
end

class HouseTyrellCard < HouseCard
  HOUSE = HouseTyrell
end

class MaceTyrell < HouseTyrellCard
  TITLE = 'Mace Tyrell'
  COMBAT_STRENGTH = 4
  TEXT = 'Immediately destroy one of your opponent\'s attacking or defending Footman units.'
end

class SerLorasTyrell < HouseTyrellCard
  TITLE = 'Ser Loras Tyrell'
  COMBAT_STRENGTH = 3
  TEXT = 'If you are attacking and win this combat, move the March Order token used into the conquested area. The March Order may be resolved again later this round.'
end

class SerGarlanTyrell < HouseTyrellCard
  TITLE = 'Ser Garlan Tyrell'
  COMBAT_STRENGTH = 2
  SWORDS = 2
end

class RandyllTarly < HouseTyrellCard
  TITLE = 'Randyll Tarly'
  COMBAT_STRENGTH = 2
  SWORDS = 2
end

class AlesterFlorent < HouseTyrellCard
  TITLE = 'Alester Florent'
  COMBAT_STRENGTH = 1
  FORTIFICATIONS = 1
end

class MargeryTyrell < HouseTyrellCard
  TITLE = 'Margery Tyrell'
  COMBAT_STRENGTH = 1
  FORTIFICATIONS = 1
end

class QueenOfThorns < HouseTyrellCard
  TITLE = 'Queen of Thorns'
  TEXT = 'Immediately remove one of your opponent\'s Order tokens in any one area, adjacent to the embattled area. You may not remove the March Order token used to start this combat.'
end

class HouseMartellCard < HouseCard
  HOUSE = HouseMartell
end

class TheRedViper < HouseMartellCard
  TITLE = 'The Red Viper'
  COMBAT_STRENGTH = 4
  SWORDS = 2
  FORTIFICATIONS = 1
end

class AreoHotah < HouseMartellCard
  TITLE = 'Areo Hotah'
  COMBAT_STRENGTH = 3
  FORTIFICATIONS = 1
end

class ObaraSand < HouseMartellCard
  TITLE = 'Obara Sand'
  COMBAT_STRENGTH = 2
  SWORDS = 1
end

class Darkstar < HouseMartellCard
  TITLE = 'Darkstar'
  COMBAT_STRENGTH = 2
  SWORDS = 1
end

class NymeriaSand < HouseMartellCard
  TITLE = 'Nymeria Sand'
  COMBAT_STRENGTH = 1
  TEXT = 'If you are defending, this card gains a fortification icon. If you are attacking, this card gains a sword icon.'
end

class ArianneMartell < HouseMartellCard
  TITLE = 'Arianne Martell'
  COMBAT_STRENGTH = 1
  TEXT = 'If you are defending and lose this combat, your opponent may not move his units into the embattled area. They return to the area from which they marched. Your own units must still retreat.'
end

class DoranMartell < HouseMartellCard
  TITLE = 'Doran Martell'
  TEXT = 'Immediately move your opponent to the bottom of one Influence track of your choice.'
end
