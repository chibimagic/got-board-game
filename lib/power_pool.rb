class PowerPool
  attr_reader :pool

  def initialize(players)
    @pool = []
    players.each do |player|
      20.times { @pool.push(PowerToken.new(player.house.class)) }
    end
  end
end
