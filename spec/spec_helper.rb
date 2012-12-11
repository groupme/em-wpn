require "rubygems"
require "bundler/setup"

require "em-wpn"
require "em-wpn/test_helper"

RSpec.configure do |config|
  config.before(:each) do
    EM::WPN.logger = Logger.new("/dev/null")
  end
end
