class WesterosDeckTest < MiniTest::Test
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
      assert_equal(d1.active_card, d2.active_card)
      refute_equal(d1.draw_pile, d2.draw_pile)
      assert_equal(d1.discard_pile, d2.discard_pile)

      10.times do
        d1.draw
        d1.discard
        d2.draw
        d2.discard
      end

      refute_equal(d1, d2)
      assert_equal(d1.active_card, d2.active_card)
      assert_equal(d1.draw_pile, d2.draw_pile)
      refute_equal(d1.discard_pile, d2.discard_pile)
    end
  end

  def test_deck_count
    @deck_classes.each do |deck_class|
      d = deck_class.create_new
      assert_equal(10, d.draw_pile.length, d.to_s + ' has wrong number of cards')
    end
  end

  def test_decision_makers
    decision_makers = []
    @deck_classes.each do |deck_class|
      deck_class.create_new.each do |card|
        if card.class::INFLUENCE_TRACK_DECISION
          decision_makers.push(card.class::INFLUENCE_TRACK_DECISION)
        end
      end
    end
    assert_equal([IronThroneTrack, FiefdomsTrack, KingsCourtTrack].to_set, decision_makers.to_set)
  end
end
