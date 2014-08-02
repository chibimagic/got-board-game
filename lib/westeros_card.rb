class WesterosCard < Card
  TITLE = ''
  TEXT = ''
  ADVANCE_WILDLINGS = false

  def title
    self.class::TITLE
  end

  def text
    self.class::TEXT
  end
end

class AThroneOfBlades < WesterosCard
  TITLE = 'A Throne of Blades'
  ADVANCE_WILDLINGS = true
  TEXT = 'The holder of the Iron Throne token chooses whether a) everyone updates their Supply, then reconcile armies b) everyone musters units, or c) this card has no effect.'
end

class ClashOfKings < WesterosCard
  TITLE = 'Clash of Kings'
  TEXT = 'Bid on the three Influence tracks.'
end

class DarkWingsDarkWords < WesterosCard
  TITLE = 'Dark Wings, Dark Words'
  ADVANCE_WILDLINGS = true
  TEXT = 'The holder of the Messenger Raven chooses whether a) everyone bids on the three Influence tracks b) everyone collects one Power token for every power icon present in areas they control, or c) this card has no effect.'
end

class FeastForCrows < WesterosCard
  TITLE = 'Feast for Crows'
  ADVANCE_WILDLINGS = true
  TEXT = 'Consolidate Power Orders cannot be played during this Planning Phase.'
end

class GameOfThrones < WesterosCard
  TITLE = 'Game of Thrones'
  TEXT = 'Each player collects one Power token for each power icon present in areas he controls.'
end

class LastDaysOfSummer < WesterosCard
  TITLE = 'Last Days of Summer'
  ADVANCE_WILDLINGS = true
  TEXT = 'Nothing happens.'
end

class Mustering < WesterosCard
  TITLE = 'Mustering'
  TEXT = 'Recruit new units in Strongholds and Castles.'
end

class PutToTheSword < WesterosCard
  TITLE = 'Put to the Sword'
  TEXT = 'The holder of the Valyrian Steel Blade chooses one of the following conditions for this Planning Phase: a) Defense Orders cannot be played b) March +1 Orders cannot be played, or c) no restrictions.'
end

class RainsOfAutumn < WesterosCard
  TITLE = 'Rains of Autum'
  ADVANCE_WILDLINGS = true
  TEXT = 'March +1 Orders cannot be played this Planning Phase.'
end

class SeaOfStorms < WesterosCard
  TITLE = 'Sea of Storms'
  ADVANCE_WILDLINGS = true
  TEXT = 'Raid Orders cannot be played during this Planning Phase.'
end

class StormOfSwords < WesterosCard
  TITLE = 'Storm of Swords'
  ADVANCE_WILDLINGS = true
  TEXT = 'Defense Orders cannot be played during this Planning Phase.'
end

class Supply < WesterosCard
  TITLE = 'Supply'
  TEXT = 'Adjust Supply track. Reconcile armies.'
end

class WebOfLies < WesterosCard
  TITLE = 'Web of Lies'
  ADVANCE_WILDLINGS = true
  TEXT = 'Support Orders cannot be placed during this Planning Phase.'
end

class WildlingsAttack < WesterosCard
  TITLE = 'Wildlings Attack'
  TEXT = 'The wildlings attack Westeros.'
end

class WinterIsComing < WesterosCard
  TITLE = 'Winter Is Coming'
  TEXT = 'Immediately shuffle this deck. Then draw and resolve a new card.'
end
