require 'set'
require_relative 'player.rb'
require_relative 'deck.rb'
require_relative 'house_card.rb'
require_relative 'house_card_deck.rb'
require_relative 'wildling_card.rb'
require_relative 'wildling_deck.rb'
require_relative 'westeros_card.rb'
require_relative 'westeros_deck.rb'
require_relative 'dominance_token.rb'
require_relative 'area.rb'
require_relative 'map.rb'
require_relative 'game_track.rb'
require_relative 'neutral_force_token.rb'
require_relative 'neutral_force_tokens.rb'
require_relative 'unit.rb'
require_relative 'house.rb'
require_relative 'houses.rb'

class Game
  attr_reader \
    :players,
    :map,
    :game_round,
    :round_phase,
    :wildling_track,
    :iron_throne_track,
    :fiefdoms_track,
    :kings_court_track

  ROUND_PHASES = [
    :westeros,
    :planning,
    :action
  ]

  def initialize(players)
    if players.length < 3 || players.length > 6
      raise 'A Game of Thrones (second edition) can only be played with 3-6 players, not ' + players.length.to_s
    end

    validate_houses(players)

    @players = players
    @map = Map.new
    @game_round = 1
    @wildling_track = WildlingTrack.new
    @iron_throne_track = IronThroneTrack.new(players)
    @fiefdoms_track = FiefdomsTrack.new(players)
    @kings_court_track = KingsCourtTrack.new(players)

    @wildling_deck = WildlingDeck.new
    @westeros_deck_i = WesterosDeckI.new
    @westeros_deck_ii = WesterosDeckII.new
    @westeros_deck_iii = WesterosDeckIII.new

    @players.each do |player|
      player.house.class::STARTING_UNITS.each do |area_class, starting_unit_classes|
        starting_unit_classes.each do |starting_unit_class|
          place_unit(player, starting_unit_class, area_class)
        end
      end
    end

    @round_phase = :planning
  end

  def validate_houses(players)
    Houses.new.each do |house|
      selected_by_players = players.find_all { |player| player.house.class == house }
      if selected_by_players.length > 1
        raise 'More than one player has chosen ' + house.to_s + ': ' + selected_by_players.join(', ')
      elsif selected_by_players.length == 1 && players.length < house::MINIMUM_PLAYERS
        raise house.to_s + ' cannot be chosen when there are ' + players.length.to_s + ' players (' + house::MINIMUM_PLAYERS.to_s + ' required)'
      end
    end
  end
  private :validate_houses

  def place_unit(player, unit_class, area_class)
    unit = player.house.units.find { |unit| unit.class == unit_class }
    if !unit
      raise player.to_s + ' does not have an available ' + unit_class.to_s + ' to place in ' + area_class.to_s
    end
    player.house.units.delete(unit)
    @map.area(area_class).tokens.push(unit_class.new(player.house))
  end
end
