require "rubygems"
require "bundler/setup"
Bundler.require :default, :development

require "em-wpn/test_helper"
require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:each) do
    EM::WPN.logger = Logger.new("/dev/null")
  end
end
