class TestWesterosCard < Test::Unit::TestCase
  def test_card_content
    decks = [WesterosDeckI, WesterosDeckII, WesterosDeckIII]
    decks.each do |deck_class|
      d = deck_class.new
      while d.cards_remaining > 0
        c = d.draw_from_top
        assert_not_equal('', c.title, c.to_s + ' has no title')
        assert_not_equal('', c.text, c.to_s + ' has no text')
      end
    end
  end
end
