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
    raise 'Invalid attacking house card' unless attacking_house_card.is_a?(HouseCard)
    raise 'Invalid defending house card' unless defending_house_card.is_a?(HouseCard)

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
end
