class Deck
  include Enumerable

  attr_reader \
    :active_card,
    :draw_pile,
    :discard_pile

  STARTING_CARD_CLASSES = []

  def initialize(active_card, draw_pile, discard_pile)
    raise 'Invalid active card' unless active_card.nil? || active_card.is_a?(Card)
    raise 'Invalid draw pile' unless draw_pile.is_a?(Array) && draw_pile.all? { |card| card.is_a?(Card) }
    raise 'Invalid discard pile' unless discard_pile.is_a?(Array) && discard_pile.all? { |card| card.is_a?(Card) }

    @active_card = active_card
    @draw_pile = draw_pile
    @discard_pile = discard_pile
  end

  def self.create_new
    active_card = nil
    draw_pile = []
    self::STARTING_CARD_CLASSES.each do |card_class|
      draw_pile.push(card_class.new)
    end
    discard_pile = []

    new(active_card, draw_pile, discard_pile)
  end

  def self.unserialize(data)
    active_card = data['active_card'].nil? ? nil : data['active_card'].constantize.new
    draw_pile = data['draw_pile'].map { |card_class_string| card_class_string.constantize.new }
    discard_pile = data['discard_pile'].map { |card_class_string| card_class_string.constantize.new }
    new(active_card, draw_pile, discard_pile)
  end

  def serialize
    {
      :active_card => @active_card.nil? ? nil : @active_card.class.name,
      :draw_pile => @draw_pile.map { |card| card.class.name },
      :discard_pile => @discard_pile.map { |card| card.class.name }
    }
  end

  def ==(o)
    self.class == o.class &&
      self.active_card == o.active_card &&
      self.draw_pile == o.draw_pile &&
      self.discard_pile == o.discard_pile
  end

  # Fulfill Enumerable
  def each(&block)
    @draw_pile.each(&block)
  end

  def draw
    unless @active_card.nil?
      raise 'Cannot draw with active card'
    end

    @active_card = @draw_pile.shift
  end

  def discard
    if @active_card.nil?
      raise 'No active card to discard'
    end

    @discard_pile.push(@active_card)
    @active_card = nil
  end
end

module ReplaceIntoDrawPileDeck
  def place_at_top
    if @active_card.nil?
      raise 'No active card to place'
    end

    @draw_pile.unshift(@active_card)
    @active_card = nil
  end

  def place_at_bottom
    if @active_card.nil?
      raise 'No active card to place'
    end

    @draw_pile.push(@active_card)
    @active_card = nil
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
