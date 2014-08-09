class TestWesterosDeck < MiniTest::Test
  def setup
    @deck_classes = [WesterosDeckI, WesterosDeckII, WesterosDeckIII]
  end

  def test_serialize
    @deck_classes.each do |deck_class|
      original_deck = deck_class.create_new
      stored_deck = original_deck.serialize.to_json
      restored_deck = deck_class.unserialize(JSON.parse(stored_deck))
      assert_equal(original_deck, restored_deck)
    end
  end

  def test_equality
    @deck_classes.each do |deck_class|
      d1 = deck_class.create_new
      d2 = deck_class.create_new
      refute_equal(d1, d2)

      10.times { d1.draw_from_top }
      10.times { d2.draw_from_top }
      assert_equal(d1, d2)
    end
  end

  def test_deck_count
    @deck_classes.each do |deck_class|
      d = deck_class.create_new
      assert_equal(10, d.cards_remaining, d.to_s + ' has wrong number of cards')
    end
  end

  def test_decision_makers
    decision_makers = []
    @deck_classes.each do |deck_class|
      deck_class.create_new.cards.each do |card|
        if card.class::INFLUENCE_TRACK_DECISION
          decision_makers.push(card.class::INFLUENCE_TRACK_DECISION)
        end
      end
    end
    assert_equal([IronThroneTrack, FiefdomsTrack, KingsCourtTrack].to_set, decision_makers.to_set)
  end
end
