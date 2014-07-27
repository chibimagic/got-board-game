require 'rails'
require_relative 'utility.rb'
require_relative 'token.rb'
require_relative 'card.rb'
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
    :players_turn,
    :wildling_track,
    :iron_throne_track,
    :fiefdoms_track,
    :kings_court_track,
    :valyrian_steel_blade_token,
    :messenger_raven_token,
    :power_pool,
    :wildling_deck,
    :westeros_deck_i,
    :westeros_deck_ii,
    :westeros_deck_iii

  ROUND_PHASES = [
    :westeros,
    :planning_assign,
    :planning_raven,
    :action
  ]

  def initialize(
    houses,
    map,
    game_round,
    round_phase,
    players_turn,
    wildling_track,
    iron_throne_track,
    fiefdoms_track,
    kings_court_track,
    valyrian_steel_blade_token,
    messenger_raven_token,
    power_pool,
    wildling_deck,
    westeros_deck_i,
    westeros_deck_ii,
    westeros_deck_iii
  )
    raise 'Invalid houses' unless houses.is_a?(Array) && houses.all? { |house| house.is_a?(House) }
    raise 'Invalid Map' unless map.is_a?(Map)
    raise 'Invalid game round' unless game_round.is_a?(Integer) && 1 <= game_round && game_round <= 10
    raise 'Invalid round phase' unless ROUND_PHASES.include?(round_phase)
    raise 'Invalid player\'s turn' unless players_turn.is_a?(Array) && players_turn.all? { |player| player < House }
    raise 'Invalid Wildling Track' unless wildling_track.is_a?(WildlingTrack)
    raise 'Invalid Iron Throne Track' unless iron_throne_track.is_a?(IronThroneTrack)
    raise 'Invalid Fiefdoms Track' unless fiefdoms_track.is_a?(FiefdomsTrack)
    raise 'Invalid King\'s Court Track' unless kings_court_track.is_a?(KingsCourtTrack)
    raise 'Invalid Valyrian Steel Blade token' unless valyrian_steel_blade_token.is_a?(ValyrianSteelBladeToken)
    raise 'Invalid Messenger Raven token' unless messenger_raven_token.is_a?(MessengerRavenToken)
    raise 'Invalid Power Pool' unless power_pool.is_a?(PowerPool)
    raise 'Invalid Wildling Deck' unless wildling_deck.is_a?(WildlingDeck)
    raise 'Invalid Westeros Deck I' unless westeros_deck_i.is_a?(WesterosDeckI)
    raise 'Invalid Westeros Deck II' unless westeros_deck_ii.is_a?(WesterosDeckII)
    raise 'Invalid Westeros Deck III' unless westeros_deck_iii.is_a?(WesterosDeckIII)

    @houses = houses
    @map = map
    @game_round = game_round
    @round_phase = round_phase
    @players_turn = players_turn
    @wildling_track = wildling_track
    @iron_throne_track = iron_throne_track
    @fiefdoms_track = fiefdoms_track
    @kings_court_track = kings_court_track
    @valyrian_steel_blade_token = valyrian_steel_blade_token
    @messenger_raven_token = messenger_raven_token
    @power_pool = power_pool
    @wildling_deck = wildling_deck
    @westeros_deck_i = westeros_deck_i
    @westeros_deck_ii = westeros_deck_ii
    @westeros_deck_iii = westeros_deck_iii
  end

  def self.create_new(houses)
    if !houses.is_a?(Array) || !houses.all? { |house| house.is_a?(House) }
      raise 'Need an array of houses'
    end
    if houses.length < 3 || houses.length > 6
      raise 'A Game of Thrones (second edition) can only be played with 3-6 players, not ' + houses.length.to_s
    end

    house_classes = houses.map { |house| house.class }
    if house_classes.uniq != house_classes
      raise 'Houses must be different'
    end
    house_classes.each do |house_class|
      if house_classes.length < house_class::MINIMUM_PLAYERS
        raise 'Cannot choose ' + house_class.to_s + ' with ' + house_classes.length.to_s + ' players'
      end
    end

    game_round = 1
    round_phase = :planning_assign
    players_turn = house_classes

    new(
      houses,
      Map.create_new(houses),
      game_round,
      round_phase,
      players_turn,
      WildlingTrack.create_new,
      IronThroneTrack.create_new(house_classes),
      FiefdomsTrack.create_new(house_classes),
      KingsCourtTrack.create_new(house_classes),
      ValyrianSteelBladeToken.create_new,
      MessengerRavenToken.create_new,
      PowerPool.create_new(house_classes),
      WildlingDeck.create_new,
      WesterosDeckI.create_new,
      WesterosDeckII.create_new,
      WesterosDeckIII.create_new
    )
  end

  def self.unserialize(data)
    new(
      data['houses'].map { |house| House.unserialize(house) },
      Map.unserialize(data['map']),
      data['game_round'],
      data['round_phase'].to_sym,
      data['players_turn'].map { |house_class_string| house_class_string.constantize },
      WildlingTrack.unserialize(data['wildling_track']),
      IronThroneTrack.unserialize(data['iron_throne_track']),
      FiefdomsTrack.unserialize(data['fiefdoms_track']),
      KingsCourtTrack.unserialize(data['kings_court_track']),
      ValyrianSteelBladeToken.unserialize(data['valyrian_steel_blade_token']),
      MessengerRavenToken.unserialize(data['messenger_raven_token']),
      PowerPool.unserialize(data['power_pool']),
      WildlingDeck.unserialize(data['wildling_deck']),
      WesterosDeckI.unserialize(data['westeros_deck_i']),
      WesterosDeckII.unserialize(data['westeros_deck_ii']),
      WesterosDeckIII.unserialize(data['westeros_deck_iii'])
    )
  end

  def serialize
    {
      :houses => @houses.map { |house| house.serialize },
      :map => @map.serialize,
      :game_round => @game_round,
      :round_phase => @round_phase,
      :players_turn => @players_turn.map { |house_class| house_class.name },
      :wildling_track => @wildling_track.serialize,
      :iron_throne_track => @iron_throne_track.serialize,
      :fiefdoms_track => @fiefdoms_track.serialize,
      :kings_court_track => @kings_court_track.serialize,
      :valyrian_steel_blade_token => @valyrian_steel_blade_token.serialize,
      :messenger_raven_token => @messenger_raven_token.serialize,
      :power_pool => @power_pool.serialize,
      :wildling_deck => @wildling_deck.serialize,
      :westeros_deck_i => @westeros_deck_i.serialize,
      :westeros_deck_ii => @westeros_deck_ii.serialize,
      :westeros_deck_iii => @westeros_deck_iii.serialize
    }
  end

  def ==(o)
    self.class == o.class &&
      @houses == o.houses &&
      @map == o.map &&
      @game_round == o.game_round &&
      @round_phase == o.round_phase &&
      @wildling_track == o.wildling_track &&
      @iron_throne_track == o.iron_throne_track &&
      @fiefdoms_track == o.fiefdoms_track &&
      @kings_court_track == o.kings_court_track &&
      @valyrian_steel_blade_token == o.valyrian_steel_blade_token &&
      @messenger_raven_token == o.messenger_raven_token &&
      @power_pool == o.power_pool &&
      @wildling_deck == o.wildling_deck &&
      @westeros_deck_i == o.westeros_deck_i &&
      @westeros_deck_ii == o.westeros_deck_ii &&
      @westeros_deck_iii == o.westeros_deck_iii
  end

  def house(house_class)
    @houses.find { |house| house.class == house_class }
  end
  private :house

  def place_token(house_class, area_class, token_class)
    token = house(house_class).get_token(token_class)
    if !token
      raise house_class.to_s + ' does not have an available ' + token_class.to_s + ' to place in ' + area_class.to_s
    end

    if token.is_a?(OrderToken)
      if @round_phase != :planning_assign
        raise 'Cannot place ' + token.to_s + ' during ' + @round_phase.to_s
      end

      if token.special
        special_allowed = @kings_court_track.special_orders_allowed(house_class)
        special_used = @map.special_orders_placed(house_class)
        if special_allowed >= special_used
          raise house_class.to_s + ' can only place ' + special_allowed.to_s + ' special ' + Utility.singular_plural(special_allowed, 'order', 'orders')
        end
      end
    end

    @map.place_token(area_class, token)
    house(house_class).remove_token(token)

    if @round_phase == :planning_assign && @map.orders_in?
      @round_phase = :planning_raven
    end
  end

  def receive_power_token(house_class)
    token = @power_pool.pool.find { |token| token.house_class == house_class }
    if !token
      raise house_class.to_s + ' does not have any available power tokens in the Power Pool'
    end
    @power_pool.remove_token(token)
    house.power_tokens.push(token)
  end

  def discard_power_token(house_class)
    token = house(house_class).power_tokens.pop
    @power_pool.pool.push(token)
  end
end
