class Decision
  attr_reader :house_class, :options, :type

  TYPES = [
    :highest_bidder,
    :lowest_bidder
  ]

  def initialize(house_class, options, type)
    raise 'Invalid house class' unless house_class.is_a?(Class) && attacking_house_class < House
    raise 'Invalid options' unless options.is_a?(Array) && options.length > 0
    raise 'Invalid type' unless TYPES.include?(type)

    @house_class = house_class
    @options = options
    @type = type
  end
end
