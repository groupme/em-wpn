module EventMachine
  module WPN
    class LogMessage
      def initialize(notification, response)
        @notification, @response = notification, response
      end

      def log
        EM::WPN.logger.debug(debug)

        if @response.success?
          EM::WPN.logger.info(message)
        else
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
        parts << "ERROR=#{@response.error}" unless @response.success?
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
