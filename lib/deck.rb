class Deck
  attr_reader :cards

  STARTING_CARD_CLASSES = []

  def initialize(cards)
    raise 'Invalid cards' unless cards.is_a?(Array) && cards.all? { |card| card.is_a?(Card) }

    @cards = cards
  end

  def self.create_new
    cards = []
    self::STARTING_CARD_CLASSES.each do |card_class|
      cards.push(card_class.new)
    end
    new(cards)
  end

  def self.unserialize(data)
    cards = data.map { |card_class_string| card_class_string.constantize.new }
    new(cards)
  end

  def serialize
    @cards.map { |card| card.class }
  end

  def ==(o)
    self.class == o.class &&
      @cards == o.cards
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
  def self.create_new
    deck = super
    deck.shuffle
    deck
  end

  def shuffle
    @cards.shuffle!
  end
end
