class HouseCardTest < MiniTest::Test
  DECK_CLASSES = [HouseStarkDeck, HouseLannisterDeck, HouseBaratheonDeck, HouseGreyjoyDeck, HouseTyrellDeck, HouseMartellDeck]

  def setup
    @decks = []
    self.class::DECK_CLASSES.each do |deck_class|
      @decks.push(deck_class.create_new)
    end
  end

  # The combat strength distribution is 4, 3, 2, 2, 1, 1, 0
  def test_deck_distribution
    @decks.each do |deck|
      c = deck.draw_pile
      assert_equal(1, c.count { |card| card.combat_strength == 4 }, deck.to_s + ' has wrong number of combat strength 4 cards')
      assert_equal(1, c.count { |card| card.combat_strength == 3 }, deck.to_s + ' has wrong number of combat strength 3 cards')
      assert_equal(2, c.count { |card| card.combat_strength == 2 }, deck.to_s + ' has wrong number of combat strength 2 cards')
      assert_equal(2, c.count { |card| card.combat_strength == 1 }, deck.to_s + ' has wrong number of combat strength 1 cards')
      assert_equal(1, c.count { |card| card.combat_strength == 0 }, deck.to_s + ' has wrong number of combat strength 0 cards')
    end
  end

  # Each card has a title
  def test_card_title
    @decks.each do |deck|
      deck.each do |card|
        refute_equal('', card.title, card.to_s + ' has no title')
      end
    end
  end

  # Each card has either swords/fortifications or text
  def test_card_content
    @decks.each do |deck|
      deck.each do |card|
        if card.swords > 0 || card.fortifications > 0
          assert_equal('', card.text, card.to_s + ' has both sword/fortifications and text')
        else
          refute_equal('', card.text, card.to_s + ' has no sword, fortiications, or text')
        end
      end
    end
  end

  def test_select
    @decks.each do |deck|
      assert_equal(7, deck.draw_pile.length)
      assert_equal(nil, deck.active_card)

      card_class = deck.draw_pile.last.class
      deck.select!(card_class)

      assert_equal(card_class, deck.active_card.class)
      assert_equal(6, deck.draw_pile.length)
    end
  end
end
