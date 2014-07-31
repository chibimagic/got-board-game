require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require_relative '../routes.rb'

require 'set'

class MiniTest::Test
  def refute_raises(msg = nil)
    if msg.nil?
      msg = ''
    else
      msg += "\n"
    end

    begin
      yield
    rescue => e
      assert(false, proc {
        exception_details(e, msg + 'Exception not expected, but raised anyway')
      })
    end
  end
end

Dir.chdir(File.dirname(__FILE__))
Dir.glob('test_*').each { |file| require_relative file }
