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
require_relative 'supply_track.rb'
require_relative 'neutral_force_token.rb'
require_relative 'neutral_force_tokens.rb'
require_relative 'power_token.rb'
require_relative 'power_pool.rb'
require_relative 'order_token.rb'
require_relative 'garrison_token.rb'
require_relative 'unit.rb'
require_relative 'house.rb'
require_relative 'game_state.rb'

class Game
  attr_accessor \
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
    :supply_track,
    :power_pool,
    :wildling_deck,
    :westeros_deck_i,
    :westeros_deck_ii,
    :westeros_deck_iii

  HOUSE_CLASSES = [
    HouseStark,
    HouseLannister,
    HouseBaratheon,
    HouseGreyjoy,
    HouseTyrell,
    HouseMartell
  ]

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
    supply_track,
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
    raise 'Invalid Supply Track' unless supply_track.is_a?(SupplyTrack)
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
    @supply_track = supply_track
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
      SupplyTrack.create_new(house_classes),
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
      SupplyTrack.unserialize(data['supply_track']),
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
      :supply_track => @supply_track.serialize,
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
      @supply_track == o.supply_track &&
      @wildling_deck == o.wildling_deck &&
      @westeros_deck_i == o.westeros_deck_i &&
      @westeros_deck_ii == o.westeros_deck_ii &&
      @westeros_deck_iii == o.westeros_deck_iii
  end

  def house(house_class)
    @houses.find { |house| house.class == house_class }
  end

  def validate_game_state!(expected_game_period, action_string)
    unless @game_state.game_period == expected_game_period
      raise 'Cannot ' + action_string + ' during ' + @game_state.to_s
    end
  end
  private :validate_game_state!

  def place_order!(house_class, area_class, order_class)
    order = house(house_class).remove_token!(order_class)

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
      @map.area(area_class).receive_token!(order)
    rescue => e
      house(house_class).receive_token(order)
      raise e
    end

    if @game_state.game_period == :assign_orders && @map.orders_in?
      @game_state.next_step
    end
  end

  def replace_order!(area_class, new_order_class)
    validate_game_state!(:messenger_raven, 'replace order')

    token = @map.area(area_class).remove_token!(OrderToken)

    if token.house_class != @kings_court_track.token_holder_class
      raise 'Only the holder of the ' + @messenger_raven_token.to_s + ' may replace an order'
    end

    begin
      @messenger_raven_token.use!
      begin
        place_order!(token.house_class, area_class, new_order_class)
      rescue => e
        @messenger_raven_token.reset
        raise e
      end
    rescue => e
      @map.area(area_class).receive_token!(token)
      raise e
    end

    house(token.house_class).receive_token(token)

    @game_state.next_step
  end

  def look_at_wildling_deck
    validate_game_state!(:messenger_raven, 'look at wildling deck')

    @messenger_raven_token.use!
    @wildling_deck.draw_from_top
  end

  def replace_wildling_card_top(card)
    validate_game_state!(:messenger_raven, 'replace card at top of wildling deck')

    @wildling_deck.place_at_top(card)
    @game_state.next_step
  end

  def replace_wildling_card_bottom(card)
    validate_game_state!(:messenger_raven, 'replace card at bottom of wildling deck')

    @wildling_deck.place_at_bottom(card)
    @game_state.next_step
  end

  def skip_messenger_raven
    validate_game_state!(:messenger_raven, 'skip messenger raven step')

    @messenger_raven_token.use!
    @game_state.next_step
  end

  def execute_raid_order!(order_area_class, target_area_class = nil)
    validate_game_state!(:resolve_raid_orders, 'execute raid order')

    unless order_area_class < Area
      raise 'Must execute raid order from area, not ' + order_area_class.to_s
    end
    unless target_area_class.nil? || target_area_class < Area
      raise 'Must target area or nil with raid order, not ' + target_area_class.to_s
    end

    if order_area_class < PortArea
      connected_areas = [order_area_class::SEA_AREA]
    elsif order_area_class < LandArea
      connected_areas = @map.connected_areas(order_area_class)
    elsif order_area_class < SeaArea
      connected_areas = @map.connected_areas(order_area_class)
      connected_port = @map.class::AREAS.find { |area| area < PortArea && area::SEA_AREA == order_area_class }
      unless connected_port.nil?
        connected_areas.push(connected_port)
      end
    else
      raise order_area_class.to_s + ' is not a valid area'
    end
    unless target_area_class.nil? || connected_areas.include?(target_area_class)
      raise 'Cannot raid from ' + order_area_class.to_s + ' to unconnected ' + target_area_class.to_s
    end

    raid_order = @map.area(order_area_class).remove_token!(OrderToken)
    raiding_house_class = raid_order.house_class
    unless target_area_class.nil?
      begin
        raided_order = @map.area(target_area_class).remove_token!(OrderToken)
        raided_house_class = raided_order.house_class
        begin
          if raiding_house_class == raided_house_class
            raise 'Cannot raid your own orders'
          end
          normal_raidable_order_classes = [SupportOrder, RaidOrder, ConsolidatePowerOrder]
          unless normal_raidable_order_classes.any? { |order_class| raided_order.is_a?(order_class) } || raid_order.special && raided_order.is_a?(DefenseOrder)
            raise 'Cannot raid ' + raided_order.to_s
          end
          if raided_order.is_a?(ConsolidatePowerOrder)
            if @power_pool.has_token?(raiding_house_class)
              token = @power_pool.remove_token!(raiding_house_class)
              house(raiding_house_class).receive_token(token)
            end
            if house(raided_house_class).has_token?(PowerToken)
              token = house(raided_house_class).remove_token!(PowerToken)
              @power_pool.receive_token(token)
            end
          end
        rescue => e
          @map.area(target_area_class).receive_token!(raided_order)
          raise e
        end
      rescue => e
        @map.area(order_area_class).receive_token!(raid_order)
        raise e
      end
    end
  end

  def execute_consolidate_power_order!(order_area_class)
    validate_game_state!(:resolve_consolidate_power_orders, 'execute consolidate power order')

    consolidate_power_order = @map.area(order_area_class).remove_token!(OrderToken)
    house_class = consolidate_power_order.house_class
    count = 1 + @map.area(order_area_class).power
    count.times do
      if @power_pool.has_token?(house_class)
        token = @power_pool.remove_token!(house_class)
        house(house_class).receive_token(token)
      end
    end
  end

  def clean_up!
    @map.each do |area|
      if area.has_token?(SupportOrder)
        token = area.remove_token!(SupportOrder)
        house(token.house_class).receive_token(token)
      elsif area.has_token?(DefenseOrder)
        token = area.remove_token!(DefenseOrder)
        house(token.house_class).receive_token(token)
      end
      area.get_tokens(Unit).each { |unit| unit.reset }
    end
    @messenger_raven_token.reset
    @valyrian_steel_blade_token.reset
  end

  def determine_winner
    victory_points = houses.map { |house| @map.victory_points(house.class) }
    candidate_house_classes = @map.houses_with_victory_points(victory_points.max)
    if candidate_house_classes.count == 1
      return candidate_house_classes.first
    end

    stronghold_counts = candidate_house_classes.map { |house_class| @map.strongholds_controlled(house_class) }
    candidate_house_classes = candidate_house_classes.find_all { |house_class| @map.strongholds_controlled(house_class) == stronghold_counts.max }
    if candidate_house_classes.count == 1
      return candidate_house_classes.first
    end

    supply_levels = candidate_house_classes.map { |house_class| @supply_track.level(house_class) }
    candidate_house_classes = candidate_house_classes.find_all { |house_class| @supply_track.level(house_class) == supply_levels.max }
    if candidate_house_classes.count == 1
      return candidate_house_classes.first
    end

    power_counts = candidate_house_classes.map { |house_class| house(house_class).count_tokens(PowerToken) }
    candidate_house_classes = candidate_house_classes.find_all { |house_class| house(house_class).count_tokens(PowerToken) == power_counts.max }
    if candidate_house_classes.count == 1
      return candidate_house_classes.first
    end

    iron_throne_positions = candidate_house_classes.map { |house_class| @iron_throne_track.position(house_class) }
    candidate_house_classes.find { |house_class| @iron_throne_track.position(house_class) == iron_throne_positions.min }
  end
end
