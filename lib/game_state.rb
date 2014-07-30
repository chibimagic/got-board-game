class GameState
  attr_reader \
    :round,
    :phase,
    :step

  PHASES = [
    :westeros,
    :planning,
    :action
  ]

  STEPS = {
    :westeros => [
    ],
    :planning => [
      :assign_orders,
      :messenger_raven
    ],
    :action => [
      :resolve_raid_orders,
      :resolve_march_orders,
      :resolve_consolidate_power_orders,
      :clean_up
    ]
  }

  def initialize(
    round,
    phase,
    step
  )
    raise 'Invalid round' unless round.is_a?(Integer) && 1 <= round && round <= 10
    raise 'Invalid phase' unless PHASES.include?(phase)
    raise 'Invalid step' unless STEPS.fetch(phase).include?(step)

    @round = round
    @phase = phase
    @step = step
  end

  def self.create_new
    round = 1
    phase = :planning
    step = :assign_orders

    new(round, phase, step)
  end

  def self.unserialize(data)
    round = data['round']
    phase = data['phase'].to_sym
    step = data['step'].to_sym

    new(round, phase, step)
  end

  def serialize
    {
      :round => @round,
      :phase => @phase,
      :step => @step
    }
  end

  def ==(o)
    self.class == o.class &&
      @round == o.round &&
      @phase == o.phase &&
      @step == o.step
  end

  def to_s
    string = 'Round ' + @round.to_s + ', ' + symbol_to_string(@phase) + ' phase'
    unless @step.nil?
      string += ', ' + symbol_to_string(@step) + ' step'
    end
  end

  def symbol_to_string(symbol)
    symbol.to_s.sub(/_/, ' ').titlecase
  end
  private :symbol_to_string

  def next_step
    current_steps = STEPS.fetch(@phase)
    current_step_index = current_steps.index(@step)
    if current_steps.nil? || current_step_index + 1 == current_steps.length
      current_phase_index = PHASES.index(@phase)
      if current_phase_index + 1 == PHASES.length
        @phase = PHASES[0]
      else
        @phase = PHASES[current_phase_index + 1]
      end
      @step = STEPS.fetch(@phase).first
    else
      @step = current_steps[current_step_index + 1]
    end
  end
end
