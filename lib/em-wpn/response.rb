# Based on:
# http://msdn.microsoft.com/en-us/library/ff941100(v=vs.92).aspx
module EventMachine
  module WPN
    class Response
      include Deferrable

      attr_reader :http

      attr_reader :id
      attr_reader :status
      attr_reader :duration
      attr_reader :error

      # Service-specific
      attr_reader :activity_id
      attr_reader :device_connection_status
      attr_reader :notification_status
      attr_reader :subscription_status

      def initialize(http, start_time = nil)
        @start_time = start_time
        @http = http

        @http.callback do |http|
          set_duration
          parse_headers(http.response_header)
          success? ? succeed(self) : fail(self)
        end

        @http.errback do |http|
          set_duration
          @error = http.error
          fail(self)
        end
      end

      private

      def set_duration
        if @start_time
          @duration = ((Time.now.to_f - @start_time) * 1000.0).round
        end
      end

      def parse_headers(headers)
        @id                       = headers["ACTIVITYID"]
        @activity_id              = @id
        @status                   = headers.status
        @device_connection_status = headers["X_DEVICECONNECTIONSTATUS"]
        @notification_status      = headers["X_NOTIFICATIONSTATUS"]
        @subscription_status      = headers["X_SUBSCRIPTIONSTATUS"]

        @error = @notification_status unless success?
      end

      def success?
        @status == 200
      end
    end
  end
end
