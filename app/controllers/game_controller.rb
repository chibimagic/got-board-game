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
require_relative '../models/game.rb'

class GameController
  def initialize(game)
    raise 'Invalid game' unless game.is_a?(Game)
    @game = game
  end

  def game
    @game
  end
end
