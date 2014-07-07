class Deck
  attr_reader :cards

  STARTING_CARD_CLASSES = []

  def initialize
    @cards = []
    self.class::STARTING_CARD_CLASSES.each do |card_class|
      @cards.push(card_class.new)
    end
  end

  def self.unserialize(data)
  end

  def serialize
    @cards.map { |card| card.class }
  end

  def cards_remaining
    @cards.length
  end
end

module DrawFromTopDeck
  def draw_from_top
    @cards.shift
  end
end

module DropFromBottomDeck
  def draw_from_bottom
    @cards.pop
  end
end

module PlaceAtTopDeck
  def place_at_top(card)
    @cards.unshift(card)
  end
end

module PlaceAtBottomDeck
  def place_at_bottom(card)
    @cards.push(card)
  end
end

class RandomDeck < Deck
  def initialize
    super
    @cards.shuffle!
  end
end
