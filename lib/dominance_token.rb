class DominanceToken < Token
  def to_s
    self.class::TITLE + ' token'
  end
end

class UsableDominanceToken < DominanceToken
  attr_reader :used

  def initialize(used)
    @used = used
  end

  def self.create_new
    used = false
    new(used)
  end

  def self.unserialize(data)
    used = data
    new(used)
  end

  def serialize
    @used
  end

  def ==(o)
    self.class == o.class &&
      @used == o.used
  end

  def use
    if @used
      raise to_s + ' has already been used'
    end

    @used = true
  end

  def reset
    @used = false
  end
end

class IronThroneToken < DominanceToken
  TITLE = 'Iron Throne'
end

class ValyrianSteelBladeToken < UsableDominanceToken
  TITLE = 'Valyrian Steel Blade'
end

class MessengerRavenToken < UsableDominanceToken
  TITLE = 'Messenger Raven'
end
