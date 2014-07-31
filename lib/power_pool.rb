class PowerPool
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
    houses = @tokens.map { |power_token| power_token.house_class }.uniq
    Hash[houses.map { |house_class| [house_class.name, @tokens.count { |power_token| power_token.house_class == house_class }] }]
  end

  def ==(o)
    self.class == o.class &&
      @tokens == o.tokens
  end

  def remove_token!(house_class)
    token = @tokens.find { |token| token.house_class == house_class }
    if token.nil?
      raise house_class.to_s + ' does not have any available power tokens in the Power Pool'
    end

    @tokens.delete_at(@tokens.index(token))
  end
end
