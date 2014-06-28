class OrderToken
  attr_reader :house, :special, :bonus

  def initialize(house, special = false, bonus = 0)
    @house = house
    @special = special
    @bonus = bonus
  end

  def to_s
    self.class::TITLE + ' (' + @house.class.to_s + ')'
  end
end

class MarchOrder < OrderToken
  TITLE = 'March Order'
end

class DefenseOrder < OrderToken
  TITLE = 'Defense Order'
end

class SupportOrder < OrderToken
  TITLE = 'Support Order'
end

class RaidOrder < OrderToken
  TITLE = 'Raid Order'
end

class ConsolidatePowerOrder < OrderToken
  TITLE = 'Consolidate Power Order'
end
