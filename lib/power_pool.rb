class PowerPool
  include ItemHolder

  def initialize(items)
    raise 'Invalid items' unless items.is_a?(Array) && items.all? { |token| token.is_a?(PowerToken) }

    @items = items
  end

  def self.create_new(house_classes)
    items = []
    house_classes.each do |house_class|
      15.times { items.push(PowerToken.new(house_class)) }
    end
    new(items)
  end

  def self.unserialize(data)
    items = []
    data.each do |house_class_string, power_token_count|
      power_token_count.times { items.push(PowerToken.new(house_class_string.constantize)) }
    end
    new(items)
  end

  def serialize
    @items.group_by { |token| token.house_class }.map { |house_class, tokens| [house_class.name, tokens.count] }.to_h
  end

  def ==(o)
    self.class == o.class &&
      self.items == o.items
  end

  def to_s
    'Power Pool'
  end

  def get_all(house_class)
    @items.find_all { |token| token.house_class == house_class }
  end
end
