require 'rails'
require_relative '../utility.rb'
require_relative '../models/token.rb'
require_relative '../models/card.rb'
require_relative '../models/deck.rb'
require_relative '../models/wildling_card.rb'
require_relative '../models/wildling_deck.rb'
require_relative '../models/dominance_token.rb'
require_relative '../models/item_holder.rb'
require_relative '../models/house_card.rb'
require_relative '../models/house_card_deck.rb'
require_relative '../models/area.rb'
require_relative '../models/map.rb'
require_relative '../models/wildling_track.rb'
require_relative '../models/influence_track.rb'
require_relative '../models/westeros_card.rb'
require_relative '../models/westeros_deck.rb'
require_relative '../models/neutral_force_token.rb'
require_relative '../models/neutral_force_tokens.rb'
require_relative '../models/power_token.rb'
require_relative '../models/power_pool.rb'
require_relative '../models/order_token.rb'
require_relative '../models/garrison_token.rb'
require_relative '../models/unit.rb'
require_relative '../models/house.rb'
require_relative '../models/combat.rb'
require_relative '../models/decision.rb'
require_relative '../models/game.rb'

class GameController
  def initialize(game)
    raise 'Invalid game' unless game.is_a?(Game)
    @game = game
  end

  def self.create_new(house_classes)
    game = Game.create_new(house_classes)
    new(game)
  end

  def game
    @game
  end

  def game_info
    game_info = @game.serialize

    if game_info[:game_stack].last == :assign_orders
      game_info[:houses].each do |house, house_info|
        house_info[:tokens].delete_if { |token| token.keys[0].constantize < OrderToken }
      end
      game_info[:map][:areas].each do |area, tokens|
        tokens.delete_if { |token| token.keys[0].constantize < OrderToken }
      end
    end

    if game_info[:bids].values.include?(nil)
      game_info.delete(:bids)
    end

    unless game_info[:combat].nil?
      if game_info[:combat][:attacking_house_card_class].nil? ^ game_info[:combat][:defending_house_card_class].nil?
        attacking_house = game_info[:combat][:attacking_house_class]
        defending_house = game_info[:combat][:defending_house_class]
        game_info[:houses][attacking_house].delete(:house_cards)
        game_info[:houses][defending_house].delete(:house_cards)
      end
    end

    game_info.delete(:wildling_deck)
    game_info.delete(:westeros_deck_i)
    game_info.delete(:westeros_deck_ii)
    game_info.delete(:westeros_deck_iii)
    game_info
  end

  def method_missing(name, *arguments)
    begin
      game = Marshal.load(Marshal.dump(@game))
      result = game.send(name, *arguments)
      @game = game
      result
    rescue => e
      raise e
    end
  end
end
