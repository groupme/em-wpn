require "em-wpn/response"
require "em-wpn/log_message"

module EventMachine
  module WPN
    class Client
      def initialize(notification)
        @notification = notification
      end

      def deliver(block = nil)
        start = Time.now.to_f
        http = EventMachine::HttpRequest.new(@notification.uri).post(
          :body => @notification.body,
          :head => @notification.headers
        )

        http.callback do
          response = Response.new(http, start)
          LogMessage.new(@notification, response).log
          block.call(response) if block
        end

        http.errback do |e|
          EM::WPN.logger.error("uuid:#{@notification.uuid} #{e.inspect}")
        end
      end
    end
  end
end
