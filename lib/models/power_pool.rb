class PowerPool
  include ItemHolder

  attr_reader :tokens

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
    @tokens.group_by { |token| token.house_class }.map { |house_class, tokens| [house_class.name, tokens.count] }.to_h
  end

  def ==(o)
    self.class == o.class &&
      self.tokens == o.tokens
  end

  def to_s
    'Power Pool'
  end

  # Fulfill ItemHolder
  def items
    @tokens
  end

  # Fulfill ItemHolder
  def get_all(house_class)
    @tokens.find_all { |token| token.house_class == house_class }
  end
end
