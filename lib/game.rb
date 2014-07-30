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
require_relative 'token_holder.rb'
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
require_relative 'game_state.rb'

class Game
  attr_reader \
    :houses,
    :map,
    :game_state,
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

  def initialize(
    houses,
    map,
    game_state,
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
    raise 'Invalid game state' unless game_state.is_a?(GameState)
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
    @game_state = game_state
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

    players_turn = house_classes

    new(
      houses,
      Map.create_new(houses),
      GameState.create_new,
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
      GameState.unserialize(data['game_state']),
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
      :game_state => @game_state.serialize,
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
      @game_state == o.game_state &&
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

  def replace_order(area_class, new_order_class)
    if @game_state.game_period != :messenger_raven
      raise 'Cannot replace order during ' + @game_state.to_s
    end

    token = @map.area(area_class).remove_token(OrderToken)

    if token.house_class != @kings_court_track.token_holder_class
      raise 'Only the holder of the ' + @messenger_raven_token.to_s + ' may replace an order'
    end

    begin
      @messenger_raven_token.use
      place_order(token.house_class, area_class, new_order_class)
    rescue => e
      @messenger_raven_token.reset
      @map.area(area_class).receive_token(token)
      raise e
    end
    house(token.house_class).receive_token(token)

    @game_state.next_step
  end

  def look_at_wildling_deck
    @messenger_raven_token.use
    @wildling_deck.draw_from_top
  end

  def replace_wildling_card_top(card)
    @wildling_deck.place_at_top(card)
    @game_state.next_step
  end

  def replace_wildling_card_bottom(card)
    @wildling_deck.place_at_bottom(card)
    @game_state.next_step
  end

  def skip_messenger_raven
    @messenger_raven_token.use
    @game_state.next_step
  end

  def place_order(house_class, area_class, order_class)
    order = house(house_class).remove_token(order_class)

    unless @game_state.game_period == :assign_orders || @game_state.game_period == :messenger_raven && house_class == @kings_court_track.token_holder_class
      raise 'Cannot place order during ' + @game_state.to_s
    end

    if order.special
      special_allowed = @kings_court_track.special_orders_allowed(house_class)
      special_used = @map.special_orders_placed(house_class)
      if special_used >= special_allowed
        raise house_class.to_s + ' can only place ' + special_allowed.to_s + ' special ' + Utility.singular_plural(special_allowed, 'order', 'orders')
      end
    end

    begin
      @map.area(area_class).receive_token(order)
    rescue => e
      house(house_class).receive_token(order)
      raise e
    end

    if @game_state.game_period == :assign_orders && @map.orders_in?
      @game_state.next_step
    end
  end

  def receive_power_token(house_class)
    token = @power_pool.remove_token(house_class)
    house(house_class).receive_token(token)
  end

  def discard_power_token(house_class)
    token = house(house_class).remove_token(PowerToken)
    @power_pool.pool.push(token)
  end
end
