class GameState
  attr_reader \
    :round,
    :order_restriction

  GAME_PERIODS = [
    [:westeros, 'Westeros', nil],
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
    round,
    game_period,
    order_retriction
  )
    raise 'Invalid round' unless round.is_a?(Integer) && 1 <= round && round <= 10
    raise 'Invalid game period' + game_period.to_s unless GAME_PERIODS.any? { |period| period[0] == game_period }
    raise 'Invalid order restriction' unless order_restriction.nil? || ORDER_RESTRICTIONS.include?(order_restriction)

    @round = round
    @game_period = game_period
    @order_restriction = order_restriction
  end

  def self.create_new
    round = 1
    game_period = :assign_orders
    order_restriction = nil

    new(round, game_period, order_restriction)
  end

  def self.unserialize(data)
    round = data['round']
    game_period = data['game_period'].to_sym
    order_restriction = data['order_restriction'].nil? ? nil : data['order_restriction'].to_sym

    new(round, game_period, order_restriction)
  end

  def serialize
    {
      :round => @round,
      :game_period => @game_period,
      :order_restriction => @order_restriction
    }
  end

  def ==(o)
    self.class == o.class &&
      @round == o.round &&
      @game_period == o.game_period &&
      @order_restriction == o.order_restriction
  end

  def to_s
    string = 'Round ' + @round.to_s + ', ' + phase + ' phase'
    unless step.nil?
      string += ', ' + step + ' step'
    end
  end

  def period_data(game_period)
    GAME_PERIODS.find { |period| period[0] == game_period }
  end

  def game_period
    period_data(@game_period)[0]
  end

  def phase
    period_data(@game_period)[1]
  end

  def step
    period_data(@game_period)[2]
  end

  def next_step
    period_index = GAME_PERIODS.index { |period| period[0] == @game_period }
    if period_index + 1 == GAME_PERIODS.length
      @round += 1
      @game_period = GAME_PERIODS[0][0]
    else
      @game_period = GAME_PERIODS[period_index + 1][0]
    end
  end
end
