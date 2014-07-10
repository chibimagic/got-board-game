class PowerPool
  attr_reader :pool

  def initialize(pool)
    raise 'Invalid pool' unless pool.is_a?(Array) && pool.all? { |token| token.is_a?(PowerToken) }

    @pool = pool
  end

  def self.create_new(house_classes)
    pool = []
    house_classes.each do |house_class|
      15.times { pool.push(PowerToken.new(house_class)) }
    end
    new(pool)
  end

  def self.unserialize(data)
    pool = []
    data.each do |house_class_string, power_token_count|
      power_token_count.times { pool.push(PowerToken.new(house_class_string.constantize)) }
    end
    new(pool)
  end

  def serialize
    houses = @pool.map { |power_token| power_token.house_class }.uniq
    Hash[houses.map { |house_class| [house_class.name, @pool.count { |power_token| power_token.house_class == house_class }] }]
  end

  def ==(o)
    self.class == o.class &&
      @pool == o.pool
  end

  def remove_token(token)
    @pool.delete_at(@pool.index(token))
  end
end
