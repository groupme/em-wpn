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
      unless instance_methods.include?(:deliver_with_testing)
        def deliver_with_testing(notification)
          EM::WPN.deliveries << notification
          deliver_without_testing(notification)
        end
        alias :deliver_without_testing :deliver
        alias :deliver :deliver_with_testing
      end
    end
  end
end
