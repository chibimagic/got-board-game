class OrderToken
  attr_reader :house, :special, :bonus

  def initialize(house, special, bonus)
    @house = house
    @special = special
    @bonus = bonus
  end
end

class MarchOrder < OrderToken
end

class DefenseOrder < OrderToken
end

class SupportOrder < OrderToken
end

class RaidOrder < OrderToken
end

class ConsolidatePowerOrder < OrderToken
end
