class DeckTest < MiniTest::Test
  class SampleDeck < Deck
    include ReplaceIntoDrawPileDeck

    STARTING_CARD_CLASSES = [
      Card
    ]
  end

  def test_errors
    d = SampleDeck.create_new
    e = assert_raises(RuntimeError) { d.discard }
    assert_equal('No active card to discard', e.message)
    e = assert_raises(RuntimeError) { d.place_at_top }
    assert_equal('No active card to place', e.message)
    e = assert_raises(RuntimeError) { d.place_at_bottom }
    assert_equal('No active card to place', e.message)
    d.draw
    e = assert_raises(RuntimeError) { d.draw }
    assert_equal('Cannot draw with active card', e.message)
    d.discard
    e = assert_raises(RuntimeError) { d.draw }
    assert_equal('Cannot draw with empty draw pile', e.message)
  end
end
