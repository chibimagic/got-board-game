require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require_relative '../routes.rb'

require 'set'

class MiniTest::Test
  def refute_raises(*)
    yield
  end
end

Dir.chdir(File.dirname(__FILE__))
Dir.glob('test_*').each { |file| require_relative file }
