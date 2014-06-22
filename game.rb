require_relative 'player.rb'
require_relative 'house.rb'
require_relative 'deck.rb'

class Game
  attr_reader \
    :players,
    :wildling_track

  def initialize(players)
    if players.length < 3 || players.length > 6
      raise 'A Game of Thrones (second edition) can only be played with 3-6 players, not ' + players.length.to_s
    end

    validate_houses(players)

    @players = players
    @wildling_track = 2

    @wildling_deck = WildlingDeck.new
    @westeros_deck_i = WesterosDeckI.new
    @westeros_deck_ii = WesterosDeckII.new
    @westeros_deck_iii = WesterosDeckIII.new
  end

  def validate_houses(players)
    available_houses = HouseDeck.new
    available_houses.deck.each do | house |
      selected_by_players = players.find_all { |player| player.house.class == house.class }
      if selected_by_players.length > 1
        raise 'More than one player has chosen ' + house.to_s + ': ' + selected_by_players.join(', ')
      elsif selected_by_players.length == 1 && players.length < house.class::MINIMUM_PLAYERS
        raise house.to_s + ' cannot be chosen when there are ' + players.length.to_s + ' players (' + house.class::MINIMUM_PLAYERS.to_s + ' required)'
      end
    end
  end
  private :validate_houses
end
