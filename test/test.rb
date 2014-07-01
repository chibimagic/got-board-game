require 'simplecov'
SimpleCov.start

require 'test/unit'
require 'rest_client'
require_relative '../routes.rb'

require 'set'

Dir.chdir(File.dirname(__FILE__))
Dir.glob('test_*').each { |file| require_relative file }
