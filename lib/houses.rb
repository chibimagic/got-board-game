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

  def each(&block)
    self.class::HOUSES.each do |house_class|
      block.call(house_class)
    end
  end

end
