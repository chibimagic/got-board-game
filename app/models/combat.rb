class Combat
  attr_reader \
    :attacking_house_class,
    :defending_house_class,
    :attacking_units,
    :supporting_areas,
    :attacking_house_card_class,
    :defending_house_card_class

  def initialize(
    attacking_house_class,
    defending_house_class,
    attacking_units,
    supporting_areas,
    attacking_house_card_class,
    defending_house_card_class
  )
    raise 'Invalid attacking house class' unless attacking_house_class.is_a?(Class) && attacking_house_class < House
    raise 'Invalid defending house class' unless defending_house_class.is_a?(Class) && defending_house_class < House
    raise 'Invalid attacking units' unless attacking_units.is_a?(Array) && attacking_units.all? { |unit| unit.is_a?(Unit) }
    raise 'Invalid supporting areas' unless supporting_areas.is_a?(Hash) && supporting_areas.keys.all? { |key| key.is_a?(Class) && key < Area } && supporting_areas.values.all? { |value| [true, false, nil].include?(value) }
    raise 'Invalid attacking house card class' unless attacking_house_card_class.nil? || attacking_house_card_class.is_a?(Class) && attacking_house_card_class < HouseCard
    raise 'Invalid defending house card class' unless defending_house_card_class.nil? || defending_house_card_class.is_a?(Class) && defending_house_card_class < HouseCard

    @attacking_house_class = attacking_house_class
    @defending_house_class = defending_house_class
    @attacking_units = attacking_units
    @supporting_areas = supporting_areas
    @attacking_house_card_class = attacking_house_card_class
    @defending_house_card_class = defending_house_card_class
  end

  def self.create_new(attacking_house_class, defending_house_class, attacking_units, supporting_area_classes)
    supporting_areas = supporting_area_classes.map { |area_class| [area_class, nil] }.to_h
    attacking_house_card_class = nil
    defending_house_card_class = nil

    new(
      attacking_house_class,
      defending_house_class,
      attacking_units,
      supporting_areas,
      attacking_house_card_class,
      defending_house_card_class
    )
  end

  def self.unserialize(data)
    return nil if data.nil?

    attacking_house_class = data['attacking_house_class'].constantize
    defending_house_class = data['defending_house_class'].constantize
    attacking_units = data['attacking_units'].map { |token| Token.unserialize(token) }
    supporting_areas = data['supporting_areas'].map { |area_class_string, support_offered| [area_class_string.constantize, support_offered] }.to_h
    attacking_house_card_class = data['attacking_house_card_class'].nil? ? nil : data['attacking_house_card_class'].constantize
    defending_house_card_class = data['defending_house_card_class'].nil? ? nil : data['defending_house_card_class'].constantize

    new(
      attacking_house_class,
      defending_house_class,
      attacking_units,
      supporting_areas,
      attacking_house_card_class,
      defending_house_card_class
    )
  end

  def serialize
    {
      :attacking_house_class => @attacking_house_class.name,
      :defending_house_class => @defending_house_class.name,
      :attacking_units => @attacking_units.map { |unit| unit.serialize },
      :supporting_areas => @supporting_areas.map { |area_class, support_offered| [area_class.name, support_offered] }.to_h
      :attacking_house_card_class => @attacking_house_card_class.nil? ? nil : @attacking_house_card_class.name,
      :defending_house_card_class => @defending_house_card_class.nil? ? nil : @defending_house_card_class.name
    }
  end

  def ==(o)
    self.class == o.class &&
      self.attacking_house_class == o.attacking_house_class &&
      self.defending_house_class == o.defending_house_class &&
      self.attacking_units == o.attacking_units &&
      self.supporting_areas == o.supporting_areas &&
      self.attacking_house_card_class == o.attacking_house_card_class &&
      self.defending_house_card_class == o.defending_house_card_class
  end

  def select_house_card(house_card)
    if house_card.house_class == @attacking_house_class
      unless @attacking_house_card_class.nil?
        raise @attacking_house_class.to_s + ' has already selected ' + @attacking_house_card_class.to_s
      end

      @attacking_house_card_class = house_card.class
    elsif house_card.house_class == @defending_house_class
      unless @defending_house_card_class.nil?
        raise @defending_house_class.to_s + ' has already selected ' + @defending_house_card_class.to_s
      end

      @defending_house_card_class = house_card.class
    else
      raise house_card.house_class.to_s + ' is not involved in the combat between ' + @attacking_house_class.to_s + ' and ' + @defending_house_class.to_s
    end
  end
end
