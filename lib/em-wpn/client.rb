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
          response = EM::WPN::Response.new(http.response_header, start)
          EM::WPN.logger.info("uuid:#{@notification.uuid} #{response}")
          block.call(response) if block
        end

        http.errback do
          EM::WPN.logger.error("uuid:#{@notification.uuid} failed")
        end
      end
    end
  end
end
