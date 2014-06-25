require 'simplecov'
SimpleCov.start

require 'test/unit'
require_relative '../lib/game.rb'

require_relative 'test_area.rb'
require_relative 'test_dominance_token.rb'
require_relative 'test_game.rb'
require_relative 'test_house_card.rb'
require_relative 'test_house.rb'
require_relative 'test_influence_track.rb'
require_relative 'test_map.rb'
require_relative 'test_neutral_force_tokens.rb'
require_relative 'test_westeros_card.rb'
require_relative 'test_westeros_deck.rb'
require_relative 'test_wildling_card.rb'
require_relative 'test_wildling_track.rb'
