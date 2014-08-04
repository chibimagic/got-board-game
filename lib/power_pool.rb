class PowerPool
  include TokenHolder

  def initialize(tokens)
    raise 'Invalid tokens' unless tokens.is_a?(Array) && tokens.all? { |token| token.is_a?(PowerToken) }

    @tokens = tokens
  end

  def self.create_new(house_classes)
    tokens = []
    house_classes.each do |house_class|
      15.times { tokens.push(PowerToken.new(house_class)) }
    end
    new(tokens)
  end

  def self.unserialize(data)
    tokens = []
    data.each do |house_class_string, power_token_count|
      power_token_count.times { tokens.push(PowerToken.new(house_class_string.constantize)) }
    end
    new(tokens)
  end

  def serialize
    houses = @tokens.map { |power_token| power_token.house_class }.uniq
    houses.map { |house_class| [house_class.name, @tokens.count { |power_token| power_token.house_class == house_class }] }.to_h
  end

  def ==(o)
    self.class == o.class &&
      @tokens == o.tokens
  end

  def to_s
    'Power Pool'
  end

  def get_tokens(house_class)
    @tokens.find_all { |token| token.house_class == house_class }
  end
end
