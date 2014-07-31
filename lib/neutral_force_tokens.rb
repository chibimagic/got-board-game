class NeutralForceTokens
  TOKENS = {
    DornishMarches => { 3 => nil, 4 => 3 },
    Highgarden => { 3 => nil },
    KingsLanding => { 3 => 5, 4 => 5, 5 => 5, 6 => 5 },
    Oldtown => { 3 => nil, 4 => 3 },
    PrincesPass => { 3 => nil, 4 => 3, 5 => 3 },
    Pyke => { 3 => nil },
    SaltShore => { 3 => nil, 4 => 3, 5 => 3 },
    Starfall => { 3 => nil, 4 => 3, 5 => 3 },
    StormsEnd => { 3 => nil, 4 => 4 },
    Sunspear => { 3 => nil, 4 => 5, 5 => 5 },
    TheBoneway => { 3 => nil, 4 => 3, 5 => 3 },
    TheEyrie => { 3 => 6, 4 => 6, 5 => 6, 6 => 6 },
    ThreeTowers => { 3 => nil, 4 => 3, 5 => 3 },
    Yronwood => { 3 => nil, 4 => 3, 5 => 3 }
  }

  def self.get_tokens(player_count)
    tokens = []
    self::TOKENS.each do |area_class, counts|
      if counts.has_key?(player_count)
        strength = counts.fetch(player_count)
        tokens.push(NeutralForceToken.new(area_class, strength))
      end
    end
    tokens
  end
end
