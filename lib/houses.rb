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

  # Fulfill Enumerable
  def each(&block)
    self.class::HOUSES.each(&block)
  end
end
