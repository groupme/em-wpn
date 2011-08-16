# Test helper for EM::WPN
#
# To use this, start by simply requiring this file after EM::WPN has already
# been loaded
#
#     require "em-wpn"
#     require "em-wpn/test_helper"
#
# This will nullify actual deliveries and instead, push them onto an accessible
# list:
#
#     expect {
#       EM::WPN.push(token, aps, custom)
#     }.to change { EM::WPN.deliveries.size }.by(1)
#
#     notification = EM::WPN.deliveries.first
#     notification.should be_an_instance_of(EM::WPN::Notification)
#     notification.payload.should == ...
#
module EventMachine
  module WPN
    def self.deliveries
      @deliveries ||= []
    end

    Client.class_eval do
      def deliver(notification)
        EM::WPN.deliveries << notification
      end
    end
  end
end
