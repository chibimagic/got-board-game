class Combat
  attr_reader \
    :attacking_area,
    :defending_area,
    :attacking_units,
    :attacking_house_card,
    :defending_house_card

  def initialize(
    attacking_area,
    defending_area,
    attacking_units,
    attacking_house_card,
    defending_house_card
  )
    raise 'Invalid attacking area' unless attacking_area.is_a?(Area)
    raise 'Invalid defending area' unless defending_area.is_a?(Area)
    raise 'Invalid attacking units' unless attacking_units.is_a?(Array) && attacking_units.all? { |unit| unit.is_a?(Unit) }
    raise 'Invalid attacking house card' unless attacking_house_card.is_a?(HouseCard) || attacking_house_card.nil?
    raise 'Invalid defending house card' unless defending_house_card.is_a?(HouseCard) || defending_house_card.nil?

    @attacking_area = attacking_area
    @defending_area = defending_area
    @attacking_units = attacking_units
    @attacking_house_card = attacking_house_card
    @defending_house_card = defending_house_card
  end

  def self.create_new(attacking_area, defending_area, attacking_units)
    attacking_house_card = nil
    defending_house_card = nil

    new(
      attacking_area,
      defending_area,
      attacking_units,
      attacking_house_card,
      defending_house_card
    )
  end

  def self.unserialize(data)
    return nil if data.nil?

    attacking_area = data['attacking_area']
    defending_area = data['defending_area']
    attacking_units = data['attacking_units']
    attacking_house_card = data['attacking_house_card']
    defending_house_card = data['defending_house_card']

    new(
      attacking_area,
      defending_area,
      attacking_units,
      attacking_house_card,
      defending_house_card
    )
  end

  def select_house_card(house_card)
    attacking_house = @attacking_area.controlling_house_class
    defending_house = @defending_area.controlling_house_class

    if house_card.house_class == attacking_house
      unless @attacking_house_card.nil?
        raise attacking_house.to_s + ' has already selected ' + @attacking_house_card.to_s
      end

      @attacking_house_card = house_card
    elsif house_card.house_class == defending_house
      unless @defending_house_card.nil?
        raise defending_house.to_s + ' has already selected ' + @defending_house_card.to_s
      end

      @defending_house_card = house_card
    else
      raise house_card.house_class.to_s + ' is not involved in the combat between ' + attacking_house.to_s + ' and ' + defending_house.to_s
    end
  end
end
