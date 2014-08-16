class Deck
  attr_reader :draw_pile, :discard_pile

  STARTING_CARD_CLASSES = []

  def initialize(draw_pile, discard_pile)
    raise 'Invalid draw pile' unless draw_pile.is_a?(Array) && draw_pile.all? { |card| card.is_a?(Card) }
    raise 'Invalid discard pile' unless discard_pile.is_a?(Array) && discard_pile.all? { |card| card.is_a?(Card) }

    @draw_pile = draw_pile
    @discard_pile = discard_pile
  end

  def self.create_new
    draw_pile = []
    self::STARTING_CARD_CLASSES.each do |card_class|
      draw_pile.push(card_class.new)
    end
    discard_pile = []
    new(draw_pile, discard_pile)
  end

  def self.unserialize(data)
    draw_pile = data['draw_pile'].map { |card_class_string| card_class_string.constantize.new }
    discard_pile = data['discard_pile'].map { |card_class_string| card_class_string.constantize.new }
    new(draw_pile, discard_pile)
  end

  def serialize
    {
      :draw_pile => @draw_pile.map { |card| card.class.name },
      :discard_pile => @discard_pile.map { |card| card.class.name }
    }
  end

  def ==(o)
    self.class == o.class &&
      @draw_pile == o.draw_pile &&
      @discard_pile == o.discard_pile
  end

  def discard(card)
    @discard_pile.push(card)
  end
end

module DrawFromTopDeck
  def draw_from_top
    @draw_pile.shift
  end
end

module PlaceAtTopDeck
  def place_at_top(card)
    @draw_pile.unshift(card)
  end
end

module PlaceAtBottomDeck
  def place_at_bottom(card)
    @draw_pile.push(card)
  end
end

class RandomDeck < Deck
  def self.create_new
    deck = super
    deck.shuffle
    deck
  end

  def shuffle
    @draw_pile.shuffle!
  end
end
