module EventMachine
  module WPN
    class LogMessage
      def initialize(notification, response)
        if ENV["VERBOSE"]
          EM::WPN.logger.debug(notification.headers.inspect)
          EM::WPN.logger.debug(notification.body)
        end

        @notification = notification
        @response = response
        @response.callback do
          EM::WPN.logger.debug(debug)
          EM::WPN.logger.debug(message)
        end
        @response.errback do
          EM::WPN.logger.debug(debug)
          EM::WPN.logger.error(message)
        end
      end

      private

      def message
        parts = [
          "CODE=#{@response.status}",
          "GUID=#{@notification.uuid}",
          "TOKEN=#{@notification.uri}",
          "TIME=#{@response.duration}"
        ]
        parts << "ERROR=#{@response.error}" if @response.error
        parts.join(" ")
      end


      def debug
        [
          "SUBSCRIPTION=#{@response.subscription_status}",
          "DEVICE=#{@response.device_connection_status}",
          "NOTIFICATION=#{@response.notification_status}",
          "ACTIVITY_ID=#{@response.activity_id}"
        ].join(" ")
      end
    end
  end
end
