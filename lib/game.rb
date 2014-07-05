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
require_relative 'order_token.rb'
require_relative 'garrison_token.rb'
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
    :planning_assign,
    :planning_raven,
    :action
  ]

  def initialize(
    houses,
    map = nil,
    game_round = 0,
    wildling_track = nil,
    iron_throne_track = nil,
    fiefdoms_track = nil,
    kings_court_track = nil,
    power_pool = nil,
    wildling_deck = nil,
    westeros_deck_i = nil,
    westeros_deck_ii = nil,
    westeros_deck_iii = nil,
    round_phase = nil
  )
    validate_houses(houses)
    @houses = houses

    if map.is_a?(Map) &&
      game_round.is_a?(Integer) && 1 <= game_round && game_round <= 10 &&
      wildling_track.is_a?(WildlingTrack) &&
      iron_throne_track.is_a?(IronThroneTrack) &&
      fiefdoms_track.is_a?(FiefdomsTrack) &&
      kings_court_track.is_a?(KingsCourtTrack) &&
      power_pool.is_a?(PowerPool) &&
      wildling_deck.is_a?(WildlingDeck) &&
      westeros_deck_i.is_a?(WesterosDeckI) &&
      westeros_deck_ii.is_a?(WesterosDeckII) &&
      westeros_deck_iii.is_a?(WesterosDeckIII) &&
      ROUND_PHASES.include?(round_phase)

      # Restore game
      @map = map
      @game_round = game_round
      @wildling_track = wildling_track
      @iron_throne_track = iron_throne_track
      @fiefdoms_track = fiefdoms_track
      @kings_court_track = kings_court_track
      @power_pool = power_pool
      @wildling_deck = wildling_deck
      @westeros_deck_i = westeros_deck_i
      @westeros_deck_ii = westeros_deck_ii
      @westeros_deck_iii = westeros_deck_iii
      @round_phase = round_phase
    else
      # New game
      @map = Map.new

      NeutralForceTokens.new(@houses.count).get_tokens.each do |token|
        @map.place_token(token.area_class, token)
      end

      @houses.each do |house|
        house.class::STARTING_UNITS.each do |area_class, starting_unit_classes|
          starting_unit_classes.each do |starting_unit_class|
            place_token(area_class, house.class, starting_unit_class)
          end
        end
        @map.place_token(house.class::HOME_AREA, GarrisonToken.new(house))
      end

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
      @round_phase = :planning_assign
    end
  end

  def self.unserialize(data)
  end

  def serialize
    {
      :houses => @houses.map { |house| house.serialize },
      :map => @map.serialize,
      :game_round => @game_round,
      :round_phase => @round_phase,
      :wildling_track => @wildling_track.serialize,
      :iron_throne_track => @iron_throne_track.serialize,
      :fiefdoms_track => @fiefdoms_track.serialize,
      :kings_court_track => @kings_court_track.serialize,
      :power_pool => @power_pool.serialize,
      :wildling_deck => @wildling_deck.serialize,
      :westeros_deck_i => @westeros_deck_i.serialize,
      :westeros_deck_ii => @westeros_deck_ii.serialize,
      :westeros_deck_iii => @westeros_deck_iii.serialize
    }.to_json
  end

  def validate_houses(houses)
    if !houses.is_a?(Array) || houses.count { |house| house.is_a?(House) } != houses.count
      raise 'Need an array of houses'
    end
    if houses.length < 3 || houses.length > 6
      raise 'A Game of Thrones (second edition) can only be played with 3-6 players, not ' + houses.length.to_s
    end
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

  def house(house_class)
    @houses.find { |house| house.class == house_class }
  end
  private :house

  def place_token(area_class, house_class, token_class)
    if token_class < OrderToken && @round_phase != :planning_assign
      raise 'Cannot place ' + token_class.to_s + ' during ' + @round_phase.to_s
    end
    token = house(house_class).get_token(token_class)
    if !token
      raise house_class.to_s + ' does not have an available ' + token_class.to_s + ' to place in ' + area_class.to_s
    end
    @map.place_token(area_class, token)
    house(house_class).remove_token(token)
    if @round_phase == :planning_assign && @map.orders_in?
      @round_phase = :planning_raven
    end
  end

  def receive_power_token(house)
    token = @power_pool.pool.find { |token| token.house == house }
    if !token
      raise house.to_s + ' does not have any available power tokens in the Power Pool'
    end
    @power_pool.pool.delete(token)
    house.power_tokens.push(token)
  end

  def discard_power_token(house)
    token = house.power_tokens.pop
    @power_pool.pool.push(token)
  end
end
