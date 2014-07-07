class PowerPool
  attr_reader :pool

  def initialize(houses)
    @pool = []
    houses.each do |house|
      15.times { @pool.push(PowerToken.new(house)) }
    end
  end

  def self.unserialize(data)
  end

  def serialize
    houses = @pool.map { |power_token| power_token.house.class }.uniq
    Hash[houses.map { |house_class| [house_class, @pool.count { |power_token| power_token.house.class == house_class }] }]
  end

  def remove_token(token)
    @pool.delete(token)
  end
end
