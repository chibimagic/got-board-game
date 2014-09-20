I18n.config.enforce_available_locales = true

class Game
  attr_accessor \
    :houses,
    :map,
    :round,
    :game_stack,
    :bids,
    :musterable_areas,
    :order_restriction,
    :combat,
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

  HOUSE_CLASSES = [
    HouseStark,
    HouseLannister,
    HouseBaratheon,
    HouseGreyjoy,
    HouseTyrell,
    HouseMartell
  ]

  GAME_PERIODS = [
    [:resolve_westeros_deck_i, 'Westeros', 'Resolve Westeros Deck I'],
    [:resolve_westeros_deck_ii, 'Westeros', 'Resolve Westeros Deck II'],
    [:resolve_westeros_deck_iii, 'Westeros', 'Resolve Westeros Deck III'],
    [:wildling_attack, 'Westeros', 'Wildling Attack'],
    [:assign_orders, 'Planning', 'Assign Orders'],
    [:messenger_raven, 'Planning', 'Messenger Raven'],
    [:resolve_raid_orders, 'Action', 'Resolve Raid Orders'],
    [:resolve_march_orders, 'Action', 'Resolve March Orders'],
    [:resolve_consolidate_power_orders, 'Action', 'Resolve Consolidate Power Orders'],
    [:clean_up, 'Action', 'Clean Up']
  ]

  ORDER_RESTRICTIONS = [
    :no_march_special,
    :no_defense,
    :no_support,
    :no_raid,
    :no_consolidate_power
  ]

  def initialize(
    houses,
    map,
    round,
    game_stack,
    bids,
    musterable_areas,
    order_restriction,
    combat,
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
    raise 'Invalid round' unless round.is_a?(Integer) && 1 <= round && round <= 10
    raise 'Invalid game stack' unless game_stack.is_a?(Array) && game_stack.all? { |game_period| GAME_PERIODS.any? { |period_info| period_info[0] == game_period } }
    raise 'Invalid bids' unless bids.is_a?(Hash) && bids.keys.to_s == houses.map { |house| house.class }.to_s && bids.values.all? { |v| v.nil? || v.is_a?(Integer) }
    raise 'Invalid musterable areas' unless musterable_areas.is_a?(Hash) && musterable_areas.all? { |area, points| area < Area && (0..2).include?(points) }
    raise 'Invalid order restriction' unless order_restriction.nil? || ORDER_RESTRICTIONS.include?(order_restriction)
    raise 'Invalid Combat' unless combat.is_a?(Combat) || combat.nil?
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
    @round = round
    @game_stack = game_stack
    @bids = bids
    @musterable_areas = musterable_areas
    @order_restriction = order_restriction
    @combat = combat
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

  def self.create_new(house_classes)
    if !house_classes.is_a?(Array) || !house_classes.all? { |house_class| house_class.is_a?(Class) && house_class < House }
      raise 'Need an array of house classes'
    end

    allowed_house_classes = allowed_house_classes_for_players(house_classes.length)
    unallowed_house_classes = house_classes - allowed_house_classes
    unless unallowed_house_classes.empty?
      raise 'Cannot choose ' + unallowed_house_classes.to_s + ' with ' + house_classes.length.to_s + ' players'
    end
    if house_classes.uniq != house_classes
      raise 'Houses must be different'
    end

    houses = house_classes.map { |house_class| house_class.create_new }
    round = 1
    game_stack = [:assign_orders]
    bids = house_classes.map { |house_class| [house_class, nil] }.to_h
    musterable_areas = {}
    order_restriction = nil
    combat = nil
    players_turn = house_classes

    new(
      houses,
      Map.create_new(houses),
      round,
      game_stack,
      bids,
      musterable_areas,
      order_restriction,
      combat,
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
      data['houses'].map { |house_class_string, house_data| house_class_string.constantize.unserialize(house_data) },
      Map.unserialize(data['map']),
      data['round'],
      data['game_stack'].map { |game_period| game_period.to_sym },
      data['bids'].map { |house_class_string, bid| [house_class_string.constantize, bid] }.to_h,
      data['musterable_areas'],
      data['order_restriction'].nil? ? nil : data['order_restriction'].to_sym,
      Combat.unserialize(data['combat']),
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
      :houses => @houses.map { |house| [house.class.name, house.serialize] }.to_h,
      :map => @map.serialize,
      :round => @round,
      :game_stack => @game_stack,
      :bids => @bids.map { |house_class, bid| [house_class.name, bid] }.to_h,
      :musterable_areas => @musterable_areas,
      :order_restriction => @order_restriction,
      :combat => @combat.nil? ? nil : @combat.serialize,
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

  def clone
    Marshal.load(Marshal.dump(self))
  end

  def ==(o)
    self.class == o.class &&
      self.houses == o.houses &&
      self.map == o.map &&
      self.round == o.round &&
      self.game_stack == o.game_stack &&
      self.bids == o.bids &&
      self.musterable_areas == o.musterable_areas &&
      self.order_restriction == o.order_restriction
      self.combat == o.combat &&
      self.wildling_track == o.wildling_track &&
      self.iron_throne_track == o.iron_throne_track &&
      self.fiefdoms_track == o.fiefdoms_track &&
      self.kings_court_track == o.kings_court_track &&
      self.valyrian_steel_blade_token == o.valyrian_steel_blade_token &&
      self.messenger_raven_token == o.messenger_raven_token &&
      self.power_pool == o.power_pool &&
      self.wildling_deck == o.wildling_deck &&
      self.westeros_deck_i == o.westeros_deck_i &&
      self.westeros_deck_ii == o.westeros_deck_ii &&
      self.westeros_deck_iii == o.westeros_deck_iii
  end

  def self.allowed_house_classes_for_players(player_count)
    unless (3..6).include?(player_count)
      raise 'Cannot play A Game of Thrones (second edition) with ' + player_count.to_s + ' ' + Utility.singular_plural(player_count, 'player', 'players')
    end

    HOUSE_CLASSES.find_all { |house_class| player_count >= house_class::MINIMUM_PLAYERS }
  end

  def house(house_class)
    @houses.find { |house| house.class == house_class }
  end

  def game_period
    @game_stack.last
  end

  def add_game_period(new_game_period)
    period_info = GAME_PERIODS.find { |period_info| period_info[0] == new_game_period }
    if period_info.nil?
      raise 'Invalid game period'
    end

    @game_stack.push(new_game_period)
    @players_turn = []
    case new_game_period
    when :assign_orders
      @players_turn = map.areas.map { |area| area.controlling_house }.uniq
    when :messenger_raven
      @players_turn = [@kings_court_track.token_holder_class]
    when :resolve_raid_orders
      next_players_turn(RaidOrder)
    when :resolve_march_orders
      next_players_turn(MarchOrder)
    when :resolve_consolidate_power_orders
      next_players_turn(ConsolidatePowerOrder)
    when :clean_up
      clean_up!
    end
  end
  private :add_game_period

  def remove_game_period
    @game_stack.pop
  end
  private :remove_game_period

  def change_game_period(new_game_period)
    remove_game_period
    add_game_period(new_game_period)
  end

  def game_period_string
    period_info = GAME_PERIODS.find { |period_info| period_info[0] == game_period }
    period_info[1] + ' phase, ' + period_info[2] + ' step'
  end

  def validate_game_state!(expected_game_period, action_string)
    unless game_period == expected_game_period
      raise 'Cannot ' + action_string + ' during ' + game_period_string
    end
  end
  private :validate_game_state!

  def validate_players_turn!(house_class)
    unless @players_turn.include?(house_class)
      raise house_class.to_s + ' cannot perform action during ' + @players_turn.to_sentence + '\'s turn'
    end
  end
  private :validate_players_turn!

  def next_players_turn(order_token_class)
    case @players_turn.length
    when 0
      player = @iron_throne_track.token_holder_class
    when 1
      player = @iron_throne_track.next_player(@players_turn.first, true)
    else
      raise 'Cannot determine next player when multiple players are active: ' + @players_turn.to_s
    end

    until @map.has_order?(order_token_class, player) ||
      @players_turn.empty? && player == @iron_throne_track.track.last ||
      !@players_turn.empty? && player == @players_turn.first
      player = @iron_throne_track.next_player(player, true)
    end

    if @map.has_order?(order_token_class, player)
      @players_turn = [player]
    else
      next_game_period =
        case order_token_class.name
        when 'RaidOrder'
          :resolve_march_orders
        when 'MarchOrder'
          :resolve_consolidate_power_orders
        when 'ConsolidatePowerOrder'
          :clean_up
        end
      change_game_period(next_game_period)
    end
  end
  private :next_players_turn

  def westeros_setup
    @round += 1
    decks = [@westeros_deck_i, @westeros_deck_ii, @westeros_deck_iii]
    decks.each do |deck|
      deck.draw
      if deck.active_card.advance_wildlings
        @wildling_track.increase
      end
    end
    change_game_period(:resolve_westeros_deck_i)

    if @wildling_track.attacks?
      add_game_period(:wildling_attack)
    end
  end
  private :westeros_setup

  def bid!(house_class, power_tokens)
    existing_bid = @bids.fetch(house_class)
    unless existing_bid.nil?
      raise house_class.to_s + ' has already bid ' + existing_bid.to_s
    end

    available_power = house(house_class).get_all(PowerToken).length
    unless available_power >= power_tokens
      raise 'Cannot bid ' + power_tokens.to_s + ' when ' + house_class.to_s + ' only has ' + available_power.to_s
    end

    @bids[house_class] = power_tokens
  end

  def muster_unit!(area_class, source_unit_class, final_unit_class, to_area_class)
    unless @musterable_areas.include?(area_class)
      raise 'Cannot muster from ' + area_class.to_s
    end

    unless source_unit_class < Footman || source_unit_class.nil?
      raise 'Cannot upgrade from ' + source_unit_class.to_s
    end

    unless final_unit_class < Unit
      raise 'Cannot muster ' + final_unit_class.to_s
    end

    unless [Footman, Knight, SiegeEngine].include?(final_unit_class) && to_area_class == area_class ||
      final_unit_class == Ship && @map.connected?(area_class, to_area_class)
      raise 'Cannot muster ' + final_unit_class.to_s + ' in ' + to_area_class.to_s
    end

    point_cost = source_unit_class.nil? ? final_unit_class::MUSTERING_COST : 1
    points_available = @musterable_areas.fetch(area_class)
    unless points_available >= point_cost
      raise 'Cannot use ' + point_cost.to_s + ' ' + Utility.singular_plural(point_cost.to_s, 'point', 'points') + ' with only ' + points_available.to_s + ' ' + Utility.singular_plural(points_available, 'point', 'points') + ' available'
    end

    house_class = area_class.controlling_house_class
    unless source_unit_class.nil?
      unit = @map.area(area_class).remove!(source_unit_class)
      house(house_class).receive(unit)
    end

    unit = house(house_class).remove!(final_unit_class)
    @map.place!(to_area_class, unit)

    @musterable_areas[area_class] -= point_cost
  end

  def finish_mustering
    @musterable_areas = {}
  end

  def place_order!(house_class, area_class, order_class)
    unless game_period == :assign_orders || game_period == :messenger_raven && house_class == @kings_court_track.token_holder_class
      raise 'Cannot place order during ' + game_period_string
    end
    validate_players_turn!(house_class)

    order = house(house_class).remove!(order_class)

    if order.special
      special_allowed = @kings_court_track.special_orders_allowed(house_class)
      special_used = @map.special_orders_placed(house_class)
      if special_used >= special_allowed
        raise house_class.to_s + ' can only place ' + special_allowed.to_s + ' special ' + Utility.singular_plural(special_allowed, 'order', 'orders')
      end
    end

    @map.place!(area_class, order)

    areas_needing_orders = @map.controlled_areas(house_class).find_all { |area| !area.has?(OrderToken) }
    if areas_needing_orders.empty?
      @players_turn.delete(house_class)
    end

    if @players_turn.empty?
      change_game_period(:messenger_raven)
    end
  end

  def replace_order!(area_class, new_order_class)
    validate_game_state!(:messenger_raven, 'replace order')

    token = @map.area(area_class).remove!(OrderToken)
    if token.house_class != @kings_court_track.token_holder_class
      raise 'Only the holder of the ' + @messenger_raven_token.to_s + ' may replace an order'
    end
    validate_players_turn!(token.house_class)
    house(token.house_class).receive(token)

    @messenger_raven_token.use!
    place_order!(token.house_class, area_class, new_order_class)

    house(token.house_class).receive(token)

    change_game_period(:resolve_raid_orders)
  end

  def look_at_wildling_deck
    validate_game_state!(:messenger_raven, 'look at wildling deck')

    @messenger_raven_token.use!
    @wildling_deck.draw
  end

  def replace_wildling_card_top
    validate_game_state!(:messenger_raven, 'replace card at top of wildling deck')

    @wildling_deck.place_at_top
    change_game_period(:resolve_raid_orders)
  end

  def replace_wildling_card_bottom
    validate_game_state!(:messenger_raven, 'replace card at bottom of wildling deck')

    @wildling_deck.place_at_bottom
    change_game_period(:resolve_raid_orders)
  end

  def skip_messenger_raven
    validate_game_state!(:messenger_raven, 'skip messenger raven step')

    @messenger_raven_token.use!
    change_game_period(:resolve_raid_orders)
  end

  def execute_raid_order!(order_area_class, target_area_class = nil)
    validate_game_state!(:resolve_raid_orders, 'execute raid order')

    unless order_area_class < Area
      raise 'Must execute raid order from area, not ' + order_area_class.to_s
    end
    unless target_area_class.nil? || target_area_class < Area
      raise 'Must target area or nil with raid order, not ' + target_area_class.to_s
    end

    connected_area_classes = @map.connected_area_classes(order_area_class)
    if order_area_class < PortArea
      connected_area_classes.reject! { |area_class| area_class < LandArea }
    elsif order_area_class < LandArea
      connected_area_classes.reject! { |area_class| area_class < PortArea }
    end
    unless target_area_class.nil? || connected_area_classes.include?(target_area_class)
      raise 'Cannot raid from ' + order_area_class.to_s + ' to unconnected ' + target_area_class.to_s
    end

    raid_order = @map.area(order_area_class).remove!(OrderToken)
    raiding_house_class = raid_order.house_class

    validate_players_turn!(raiding_house_class)
    house(raiding_house_class).receive(raid_order)

    unless target_area_class.nil?
      raided_order = @map.area(target_area_class).remove!(OrderToken)
      raided_house_class = raided_order.house_class
      if raiding_house_class == raided_house_class
        raise 'Cannot raid your own orders'
      end
      normal_raidable_order_classes = [SupportOrder, RaidOrder, ConsolidatePowerOrder]
      unless normal_raidable_order_classes.any? { |order_class| raided_order.is_a?(order_class) } || raid_order.special && raided_order.is_a?(DefenseOrder)
        raise 'Cannot raid ' + raided_order.to_s
      end
      house(raided_house_class).receive(raided_order)

      if raided_order.is_a?(ConsolidatePowerOrder)
        if @power_pool.has?(raiding_house_class)
          token = @power_pool.remove!(raiding_house_class)
          house(raiding_house_class).receive(token)
        end
        if house(raided_house_class).has?(PowerToken)
          token = house(raided_house_class).remove!(PowerToken)
          @power_pool.receive(token)
        end
      end
    end

    next_players_turn(RaidOrder)
  end

  # area_classes_to_unit_classes: { CastleBlack => [Footman], Karhold => [Knight, SiegeEngine], Winterfell => [Footman] }
  def execute_march_order!(order_area_class, area_classes_to_unit_classes, establish_control)
    validate_game_state!(:resolve_march_orders, 'execute march order')
    march_order = @map.area(order_area_class).remove!(OrderToken)
    validate_players_turn!(march_order.house_class)

    # Verify units
    marched_unit_classes = area_classes_to_unit_classes.values.flatten
    existing_unit_classes = @map.area(order_area_class).get_all(Unit).map { |unit| unit.class }
    if marched_unit_classes.sort_by { |item| item.name } != existing_unit_classes.sort_by { |item| item.name }
      raise 'Marched units ' + marched_unit_classes.to_s + ' must match existing units in ' + order_area_class.to_s + ' ' + existing_unit_classes.to_s
    end

    # Verify areas
    area_classes_to_unit_classes.keys.each do |target_area_class|
      unless order_area_class == target_area_class ||
        @map.connected?(order_area_class, target_area_class) ||
        @map.connected_via_ship_transport?(march_order.house_class, order_area_class, target_area_class)
        raise 'Cannot march from ' + order_area_class.to_s + ' to unconnected ' + target_area_class.to_s
      end
      if target_area_class < PortArea && @map.area(target_area_class).enemy_controlled?(march_order.house_class)
        raise 'Cannot initiate combat in port area ' + target_area_class.to_s
      end
    end

    # Verify combat count
    combat_trigger_areas = area_classes_to_unit_classes.keys.find_all { |area_class| @map.area(area_class).enemy_controlled?(march_order.house_class) }
    if combat_trigger_areas.length > 1
      raise 'Cannot march into more than one area containing units of another House: ' + combat_trigger_areas.to_s
    end

    # Verify establish control
    if area_classes_to_unit_classes.has_key?(order_area_class) && !area_classes_to_unit_classes.fetch(order_area_class).empty?
      unless establish_control.nil?
        raise 'Cannot specify Establish Control when not vacating ' + order_area_class.to_s
      end
    else
      unless [true, false].include?(establish_control)
        raise 'Must specify Establish Control when vacating ' + order_area_class.to_s
      end
    end

    # Execute non-combat movement first
    house(march_order.house_class).receive(march_order)
    attacking_units = []
    area_classes_to_unit_classes.each do |target_area_class, unit_classes|
      unit_classes.each do |unit_class|
        unit = @map.area(order_area_class).remove!(unit_class)
        if combat_trigger_areas.include?(target_area_class)
          attacking_units.push(unit)
        else
          @map.place!(target_area_class, unit)
        end
      end
    end

    if establish_control
      power_token = house(march_order.house_class).remove!(PowerToken)
      @map.place!(order_area_class, power_token)
    end

    if combat_trigger_areas.empty?
      next_players_turn(MarchOrder)
    else
      attacking_house_class = march_order.house_class
      defending_house_class = @map.area(combat_trigger_areas.first).controlling_house_class
      @combat = Combat.create_new(attacking_house_class, defending_house_class, attacking_units)
    end
  end

  def select_house_card(house_card_class)
    validate_game_state!(:resolve_march_orders, 'select house card')

    if @combat.nil?
      raise 'Cannot select house card when there is no combat'
    end

    card = house(house_card_class::HOUSE).house_cards.select!(house_card_class)
    @combat.select_house_card(card)
  end

  def execute_consolidate_power_order!(order_area_class)
    validate_game_state!(:resolve_consolidate_power_orders, 'execute consolidate power order')

    consolidate_power_order = @map.area(order_area_class).remove!(OrderToken)
    house_class = consolidate_power_order.house_class
    validate_players_turn!(house_class)
    house(house_class).receive(consolidate_power_order)

    if order_area_class < PortArea
      connected_sea_class = @map.connected_sea_classes(order_area_class).first
      return if @map.area(connected_sea_class).enemy_controlled?(house_class)
    end

    count = 1 + @map.area(order_area_class).power
    count.times do
      if @power_pool.has?(house_class)
        token = @power_pool.remove!(house_class)
        house(house_class).receive(token)
      end
    end

    next_players_turn(ConsolidatePowerOrder)
  end

  def clean_up!
    @map.each do |area|
      if area.has?(SupportOrder)
        token = area.remove!(SupportOrder)
        house(token.house_class).receive(token)
      elsif area.has?(DefenseOrder)
        token = area.remove!(DefenseOrder)
        house(token.house_class).receive(token)
      end
      area.get_all(Unit).each { |unit| unit.reset }
    end
    @messenger_raven_token.reset
    @valyrian_steel_blade_token.reset

    if @round == 10
      determine_winner
    else
      westeros_setup
    end
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

    supply_levels = candidate_house_classes.map { |house_class| @map.supply_level(house_class) }
    candidate_house_classes = candidate_house_classes.find_all { |house_class| @map.supply_level(house_class) == supply_levels.max }
    if candidate_house_classes.count == 1
      return candidate_house_classes.first
    end

    power_counts = candidate_house_classes.map { |house_class| house(house_class).count(PowerToken) }
    candidate_house_classes = candidate_house_classes.find_all { |house_class| house(house_class).count(PowerToken) == power_counts.max }
    if candidate_house_classes.count == 1
      return candidate_house_classes.first
    end

    iron_throne_positions = candidate_house_classes.map { |house_class| @iron_throne_track.position(house_class) }
    candidate_house_classes.find { |house_class| @iron_throne_track.position(house_class) == iron_throne_positions.min }
  end
end
