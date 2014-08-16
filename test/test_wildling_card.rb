class TestWildlingCard < MiniTest::Test
  # Every card has title, lowest bidder text, everyone else text, and highest bidder text
  def test_card_content
    d = WildlingDeck.create_new
    d.draw_pile.length.times {
      d.draw_from_top
      c = d.active_card
      refute_equal('', c.title, c.to_s + ' has no title')
      refute_equal('', c.lowest_bidder_text, c.to_s + ' has no lowest bidder text')
      refute_equal('', c.everyone_else_text, c.to_s + ' has no everyone else text')
      refute_equal('', c.highest_bidder_text, c.to_s + ' has no highest bidder text')
      d.discard
    }
  end
end
