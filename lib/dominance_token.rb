class DominanceToken < Token
end

class UsableDominanceToken < DominanceToken
  attr_reader :used

  def initialize
    @used = false
  end

  def use
    if @used
      raise 'This token has already been used'
    end

    @used = true
  end

  def reset
    @used = false
  end
end

class IronThroneToken < DominanceToken
end

class ValyrianSteelBladeToken < UsableDominanceToken
end

class MessengerRavenToken < UsableDominanceToken
end
