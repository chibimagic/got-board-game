class Combat
  attr_reader \
    :attacking_house_class,
    :defending_house_class,
    :attacking_units,
    :attacking_house_card_class,
    :defending_house_card_class

  def initialize(
    attacking_house_class,
    defending_house_class,
    attacking_units,
    attacking_house_card_class,
    defending_house_card_class
  )
    raise 'Invalid attacking house class' unless attacking_house_class.is_a?(Class) && attacking_house_class < House
    raise 'Invalid defending house class' unless defending_house_class.is_a?(Class) && defending_house_class < House
    raise 'Invalid attacking units' unless attacking_units.is_a?(Array) && attacking_units.all? { |unit| unit.is_a?(Unit) }
    raise 'Invalid attacking house card class' unless attacking_house_card_class.nil? || attacking_house_card_class.is_a?(Class) && attacking_house_card_class < HouseCard
    raise 'Invalid defending house card class' unless defending_house_card_class.nil? || defending_house_card_class.is_a?(Class) && defending_house_card_class < HouseCard

    @attacking_house_class = attacking_house_class
    @defending_house_class = defending_house_class
    @attacking_units = attacking_units
    @attacking_house_card_class = attacking_house_card_class
    @defending_house_card_class = defending_house_card_class
  end

  def self.create_new(attacking_house_class, defending_house_class, attacking_units)
    attacking_house_card_class = nil
    defending_house_card_class = nil

    new(
      attacking_house_class,
      defending_house_class,
      attacking_units,
      attacking_house_card_class,
      defending_house_card_class
    )
  end

  def self.unserialize(data)
    return nil if data.nil?

    attacking_house_class = data['attacking_house_class']
    defending_house_class = data['defending_house_class']
    attacking_units = data['attacking_units']
    attacking_house_card_class = data['attacking_house_card']
    defending_house_card_class = data['defending_house_card']

    new(
      attacking_house_class,
      defending_house_class,
      attacking_units,
      attacking_house_card_class,
      defending_house_card_class
    )
  end

  def select_house_card(house_card)
    if house_card.house_class == @attacking_house_class
      unless @attacking_house_card.nil?
        raise @attacking_house_class.to_s + ' has already selected ' + @attacking_house_card.to_s
      end

      @attacking_house_card_class = house_card.class
    elsif house_card.house_class == @defending_house_class
      unless @defending_house_card.nil?
        raise @defending_house_class.to_s + ' has already selected ' + @defending_house_card.to_s
      end

      @defending_house_card_class = house_card.class
    else
      raise house_card.house_class.to_s + ' is not involved in the combat between ' + @attacking_house_class.to_s + ' and ' + @defending_house_class.to_s
    end
  end
end
