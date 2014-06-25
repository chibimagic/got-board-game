class TestNeutralForceToken < Test::Unit::TestCase
  def test_token_counts
    data = [
      {
        :players => 3,
        :tokens => {
          DornishMarches => nil,
          Highgarden => nil,
          KingsLanding => 5,
          Oldtown => nil,
          PrincesPass => nil,
          Pyke => nil,
          SaltShore => nil,
          Starfall => nil,
          StormsEnd => nil,
          Sunspear => nil,
          TheBoneway => nil,
          TheEyrie => 6,
          ThreeTowers => nil,
          Yronwood => nil
        }
      },
      {
        :players => 4,
        :tokens => {
          DornishMarches => 3,
          KingsLanding => 5,
          Oldtown => 3,
          PrincesPass => 3,
          SaltShore => 3,
          Starfall => 3,
          StormsEnd => 4,
          Sunspear => 5,
          TheBoneway => 3,
          TheEyrie => 6,
          ThreeTowers => 3,
          Yronwood => 3
        }
      },
      {
        :players => 5,
        :tokens => {
          PrincesPass => 3,
          KingsLanding => 5,
          SaltShore => 3,
          Starfall => 3,
          Sunspear => 5,
          TheBoneway => 3,
          TheEyrie => 6,
          ThreeTowers => 3,
          Yronwood => 3
        }
      },
      {
        :players => 6,
        :tokens => {
          KingsLanding => 5,
          TheEyrie => 6
        }
      }
    ]
    data.each do |datum|
      tokens = NeutralForceTokens.new(datum[:players]).get_tokens
      datum[:tokens].each do |area_class, strength|
        token = tokens.find { |token| token.area_class == area_class }
        assert_not_nil(token, datum[:players].to_s + ' player game should have token for ' + area_class.to_s)
        assert_equal(strength, token.strength, datum[:players].to_s + ' player game should have ' + area_class.to_s + ' token with strength ' + strength.to_s)
      end
      assert_equal(datum[:tokens].length, tokens.length)
    end
  end
end
