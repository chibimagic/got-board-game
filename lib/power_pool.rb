class PowerPool
  attr_reader :pool

  def initialize(houses)
    @pool = []
    houses.each do |house|
      15.times { @pool.push(PowerToken.new(house.class)) }
    end
  end

  def self.unserialize(data)
  end

  def serialize
    houses = @pool.map { |power_token| power_token.house_class }.uniq
    Hash[houses.map { |house_class| [house_class, @pool.count { |power_token| power_token.house_class == house_class }] }]
  end

  def ==(o)
    self.class == o.class &&
      @pool == o.pool
  end

  def remove_token(token)
    @pool.delete_at(@pool.index(token))
  end
end
