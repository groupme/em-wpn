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
#       EM::WPN.push(notification)
#     }.to change { EM::WPN.deliveries.size }.by(1)
#
#     notification = EM::WPN.deliveries.first
#     notification.should be_an_instance_of(EM::WPN::Notification)
#     notification.body.should == ...
#
module EventMachine
  module WPN
    def self.deliveries
      @deliveries ||= []
    end

    Client.class_eval do
      def deliver(block = nil)
        EM::WPN.deliveries << @notification
      end
    end
  end
end
