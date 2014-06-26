class PowerPool
  attr_reader :pool

  def initialize(houses)
    @pool = []
    houses.each do |house|
      20.times { @pool.push(PowerToken.new(house)) }
    end
  end
end
