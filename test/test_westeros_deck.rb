class TestWesterosDeck < MiniTest::Test
  def setup
    @deck_classes = [WesterosDeckI, WesterosDeckII, WesterosDeckIII]
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
end
