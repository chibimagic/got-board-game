require 'set'
require_relative 'deck.rb'
require_relative 'house_card.rb'
require_relative 'house_card_deck.rb'
require_relative 'wildling_card.rb'
require_relative 'wildling_deck.rb'
require_relative 'westeros_card.rb'
require_relative 'westeros_deck.rb'
require_relative 'dominance_token.rb'
require_relative 'area.rb'
require_relative 'map.rb'
require_relative 'wildling_track.rb'
require_relative 'influence_track.rb'
require_relative 'neutral_force_token.rb'
require_relative 'neutral_force_tokens.rb'
require_relative 'power_token.rb'
require_relative 'power_pool.rb'
require_relative 'unit.rb'
require_relative 'house.rb'
require_relative 'houses.rb'

class Game
  attr_reader \
    :houses,
    :map,
    :game_round,
    :round_phase,
    :wildling_track,
    :iron_throne_track,
    :fiefdoms_track,
    :kings_court_track,
    :power_pool

  ROUND_PHASES = [
    :westeros,
    :planning,
    :action
  ]

  def initialize(houses)
    if houses.length < 3 || houses.length > 6
      raise 'A Game of Thrones (second edition) can only be played with 3-6 players, not ' + houses.length.to_s
    end

    validate_houses(houses)

    @houses = houses
    @map = Map.new
    @game_round = 1
    @wildling_track = WildlingTrack.new
    @iron_throne_track = IronThroneTrack.new(@houses)
    @fiefdoms_track = FiefdomsTrack.new(@houses)
    @kings_court_track = KingsCourtTrack.new(@houses)
    @power_pool = PowerPool.new(@houses)

    @wildling_deck = WildlingDeck.new
    @westeros_deck_i = WesterosDeckI.new
    @westeros_deck_ii = WesterosDeckII.new
    @westeros_deck_iii = WesterosDeckIII.new

    NeutralForceTokens.new(@houses.count).get_tokens.each do |token|
      @map.area(token.area_class).tokens.push(token)
    end

    @houses.each do |house|
      house.class::STARTING_UNITS.each do |area_class, starting_unit_classes|
        starting_unit_classes.each do |starting_unit_class|
          place_unit(house, starting_unit_class, area_class)
        end
      end
    end

    @round_phase = :planning
  end

  def validate_houses(houses)
    Houses.new.each do |house_class|
      selected_times = houses.count { |house| house.class == house_class }
      if selected_times > 1
        raise 'Multiple instances of ' + house_class.to_s
      elsif selected_times == 1 && houses.length < house_class::MINIMUM_PLAYERS
        raise house_class.to_s + ' cannot be chosen when there are ' + houses.length.to_s + ' houses (' + house_class::MINIMUM_PLAYERS.to_s + ' required)'
      end
    end
  end
  private :validate_houses

  def place_unit(house, unit_class, area_class)
    unit = house.units.find { |unit| unit.class == unit_class }
    if !unit
      raise house.to_s + ' does not have an available ' + unit_class.to_s + ' to place in ' + area_class.to_s
    end
    house.units.delete(unit)
    @map.area(area_class).tokens.push(unit_class.new(house))
  end
end
