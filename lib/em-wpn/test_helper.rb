# RSpec helper for EM::WPN
#
# To use this, start by simply requiring this file after EM::WPN has already
# been loaded
#
#     require "em-wpn"
#     require "em-wpn/test_helper"
#
# This lets you easily stub and mock deliveries (using WebMock):
#
#     notification = EM::WPN::Toast.new(URL, :text1 => "Hello world")
#
#     request_stub = EM::WPN.stub(notification).to_return(:status => 200)
#
#     # Do work...
#
#     request_stub.should have_been_requested
#
require 'webmock/rspec'

module EventMachine
  module WPN
    class << self
      def stub(notification)
        WebMock::API.stub_request(:post, notification.uri).with(
          :body    => notification.body,
          :headers => notification.headers
        )
      end
    end
  end
end
