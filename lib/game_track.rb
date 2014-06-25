require 'set'

class GameTrack
end

class WildlingTrack < GameTrack
  attr_reader :strength

  def initialize
    @strength = 2
  end

  def increase
    @strength = [@strength + 2, 12].min
  end

  def nights_watch_victory
    @strength = 0
  end

  def wildling_victory
    @strength = [@strength - 4, 0].max
  end
end

class InfluenceTrack < GameTrack
  attr_reader :track

  def initialize(players)
    @track = Array.new(6)
    players.each do |player|
      position = player.house.class::STARTING_POSITIONS[self.class]
      @track[position - 1] = player.house.class
    end
    @track.delete(nil) # Fill in empty spots from missing players
  end
end

class IronThroneTrack < InfluenceTrack
end

class FiefdomsTrack < InfluenceTrack
end

class KingsCourtTrack < InfluenceTrack
end
