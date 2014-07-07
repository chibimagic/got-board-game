class Houses
  include Enumerable

  HOUSES = [
    HouseStark,
    HouseLannister,
    HouseBaratheon,
    HouseGreyjoy,
    HouseTyrell,
    HouseMartell
  ]

  def self.get_house_class(house_string)
    house = self::HOUSES.find { |house_class| house_class.to_s == house_string }
    if house
      house
    else
      raise 'Cannot find ' + house_string + '. Try one of: ' + self::HOUSES.map { |house_class| house_class.to_s }.join(', ')
    end
  end

  def each(&block)
    self.class::HOUSES.each do |house_class|
      block.call(house_class)
    end
  end
end
