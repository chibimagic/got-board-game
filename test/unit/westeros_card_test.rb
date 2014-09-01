class WesterosCardTest < MiniTest::Test
  def test_card_content
    decks = [WesterosDeckI, WesterosDeckII, WesterosDeckIII]
    decks.each do |deck_class|
      d = deck_class.create_new
      d.each do |c|
        refute_equal('', c.title, c.to_s + ' has no title')
        refute_equal('', c.text, c.to_s + ' has no text')
      end
    end
  end
end
