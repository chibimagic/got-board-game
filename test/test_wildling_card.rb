require 'test/unit'
require_relative '../lib/game.rb'

class TestWildlingCard < Test::Unit::TestCase
  # Every card has title, lowest bidder text, everyone else text, and highest bidder text
  def test_card_content
    d = WildlingDeck.new
    d.cards_remaining.times {
      c = d.draw_from_top
      assert_not_equal('', c.title, c.to_s + ' has no title')
      assert_not_equal('', c.lowest_bidder_text, c.to_s + ' has no lowest bidder text')
      assert_not_equal('', c.everyone_else_text, c.to_s + ' has no everyone else text')
      assert_not_equal('', c.highest_bidder_text, c.to_s + ' has no highest bidder text')
    }
  end
end
