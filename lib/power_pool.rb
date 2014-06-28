class PowerPool
  attr_reader :pool

  def initialize(houses)
    @pool = []
    houses.each do |house|
      15.times { @pool.push(PowerToken.new(house)) }
    end
  end
end
