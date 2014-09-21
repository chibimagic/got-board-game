class WildlingCard < Card
  TITLE = ''
  LOWEST_BIDDER = ''
  EVERYONE_ELSE = ''
  HIGHEST_BIDDER = ''

  def title
    self.class::TITLE
  end

  def lowest_bidder_text
    self.class::LOWEST_BIDDER
  end

  def everyone_else_text
    self.class::EVERYONE_ELSE
  end

  def highest_bidder_text
    self.class::HIGHEST_BIDDER
  end

  def lowest_bidder(house_class, game)
    raise to_s + ' must implement lowest bidder'
  end

  def everyone_else(house_classes, game)
    raise to_s + ' must implement everyone else'
  end

  def highest_bidder(house_class, game)
    raise to_s + ' must implement highest bidder'
  end
end

class AKingBeyondTheWall < WildlingCard
  TITLE = 'A King Beyond the Wall'
  LOWEST_BIDDER = 'Moves his tokens to the lowest position of every Influence track.'
  EVERYONE_ELSE = 'In turn order, each player chooses either the Fiefdoms or King\'s Court Influence track and moves his token to the lowest position of that track.'
  HIGHEST_BIDDER = 'Moves his token to the top of one Influence track of his choice, then takes the appropriate Dominance token.'
end

class CrowKillers < WildlingCard
  TITLE = 'Crow Killers'
  LOWEST_BIDDER = 'Replaces all of his Knights with available Footmen. Any Knight unable to be replaced is destroyed.'
  EVERYONE_ELSE = 'Replaces 2 of their Knights with available Footmen. Any Knight unable to be replaced is destroyed.'
  HIGHEST_BIDDER = 'May immediately replace up to 2 of his Footmen, anywhere, with available Knights.'
end

class MammothRiders < WildlingCard
  TITLE = 'Mammoth Riders'
  LOWEST_BIDDER = 'Destroys 3 of his units anywhere.'
  EVERYONE_ELSE = 'Destroys 2 of their units anywhere.'
  HIGHEST_BIDDER = 'May retrieve 1 House card of his choice from his House card discard pile.'
end

class MassingOnTheMilkwater < WildlingCard
  TITLE = 'Massing on the Milkwater'
  LOWEST_BIDDER = 'If he has more than one House card in his hand, he discards all cards with the highest combat strength.'
  EVERYONE_ELSE = 'If they have more than one House card in their hand, they must choose and discard one of those cards.'
  HIGHEST_BIDDER = 'Returns his entire House card discard pile into his hand.'
end

class PreemptiveRaid < WildlingCard
  TITLE = 'Preemptive Raid'
  LOWEST_BIDDER = 'Choose one of the following: A. Destroys 2 of his units anywhere. B. Is reduced 2 positions on his highest Influence track.'
  EVERYONE_ELSE = 'Nothing happens.'
  HIGHEST_BIDDER = 'The wildlings immediately attack again with a strength of 6. You do not participate in the bidding against this attack. (nor do you receive any rewards or penalties)'
end

class RattleshirtsRaiders < WildlingCard
  TITLE = 'Rattleshirt\'s Raiders'
  LOWEST_BIDDER = 'Is reduced 2 positions on the Supply track (to no lower than 0).'
  EVERYONE_ELSE = 'Is reduced 1 position on the Supply track (to no lower than 0). Then reconcile armies to their new supply limits.'
  HIGHEST_BIDDER = 'Is increased 1 position on the Supply track (to no higher than 6).'
end

class SilenceAtTheWall < WildlingCard
  TITLE = 'Silence at the Wall'
  LOWEST_BIDDER = 'Nothing happens.'
  EVERYONE_ELSE = 'Nothing happens.'
  HIGHEST_BIDDER = 'Nothing happens.'
end

class SkinchangerScout < WildlingCard
  TITLE = 'Skinchanger Scout'
  LOWEST_BIDDER = 'Discards all available Power tokens.'
  EVERYONE_ELSE = 'Discards 2 available Power tokens, or as many as they are able.'
  HIGHEST_BIDDER = 'All Power tokens he bid on this attack are immediately returned to his available Power.'
end

class TheHordeDescends < WildlingCard
  TITLE = 'The Horde Descends'
  LOWEST_BIDDER = 'Destroys 2 of his units at one of his Castles or Strongholds. If unable, he destroys 2 of his units anywhere.'
  EVERYONE_ELSE = 'Destroys 1 of their units anywhere.'
  HIGHEST_BIDDER = 'May muster forces (following normal mustering rules) in any one Castle or Stronghold area he controls.'
end
