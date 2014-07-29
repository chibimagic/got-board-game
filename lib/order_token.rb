class OrderToken < HouseToken
  TITLE = 'Order Token'
  SPECIAL = false
  BONUS = 0

  def self.special
    self::SPECIAL
  end

  def special
    self.class::SPECIAL
  end

  def bonus
    self.class::BONUS
  end
end

class MarchOrder < OrderToken
  TITLE = 'March Order'
end

class WeakMarchOrder < MarchOrder
  BONUS = -1
end

class SpecialMarchOrder < MarchOrder
  SPECIAL = true
  BONUS = 1
end

class DefenseOrder < OrderToken
  TITLE = 'Defense Order'
  BONUS = 1
end

class SpecialDefenseOrder < DefenseOrder
  SPECIAL = true
  BONUS = 2
end

class SupportOrder < OrderToken
  TITLE = 'Support Order'
end

class SpecialSupportOrder < SupportOrder
  SPECIAL = true
  BONUS = 1
end

class RaidOrder < OrderToken
  TITLE = 'Raid Order'
end

class SpecialRaidOrder < RaidOrder
  SPECIAL = true
end

class ConsolidatePowerOrder < OrderToken
  TITLE = 'Consolidate Power Order'
end

class SpecialConsolidatePowerOrder < ConsolidatePowerOrder
  SPECIAL = true
end
