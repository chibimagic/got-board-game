class Combat
  attr_reader \
    :attacking_area,
    :defending_area,
    :attacking_units

  def initialize(
    attacking_area,
    defending_area,
    attacking_units
  )
    raise 'Invalid attacking area' unless attacking_area.is_a?(Area)
    raise 'Invalid defending area' unless defending_area.is_a?(Area)
    raise 'Invalid attacking units' unless attacking_units.is_a?(Array) && attacking_units.all? { |unit| unit.is_a?(Unit) }

    @attacking_area = attacking_area
    @defending_area = defending_area
    @attacking_units = attacking_units
  end

  def self.create_new(attacking_area, defending_area, attacking_units)
    new(
      attacking_area,
      defending_area,
      attacking_units
    )
  end
end
