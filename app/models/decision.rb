class Decision
  attr_reader :house_class, :options

  def initialize(house_class, options)
    raise 'Invalid house class' unless house_class.is_a?(Class) && attacking_house_class < House
    raise 'Invalid options' unless options.is_a?(Array) && options.length > 0

    @house_class = house_class
    @options = options
  end
end
