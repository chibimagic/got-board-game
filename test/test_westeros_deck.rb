class TestWesterosDeck < Test::Unit::TestCase
  def test_deck_count
    decks = [WesterosDeckI, WesterosDeckII, WesterosDeckIII]
    decks.each do |deck_class|
      d = deck_class.new
      assert_equal(10, d.cards_remaining, d.to_s + ' has wrong number of cards')
    end
  end
end
