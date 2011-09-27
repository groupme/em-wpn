# Based on:
# http://msdn.microsoft.com/en-us/library/ff941100(v=vs.92).aspx
module EventMachine
  module WPN
    class Response
      attr_reader :id
      attr_reader :status
      attr_reader :duration
      attr_reader :error

      # Service-specific
      attr_reader :activity_id
      attr_reader :device_connection_status
      attr_reader :notification_status
      attr_reader :subscription_status

      def initialize(http = {}, start = nil)
        @duration = compute_duration(start)

        if http.kind_of?(Hash)
          from_hash(http)
        else
          from_http(http)
        end
      end

      def success?
        @status == 200
      end

      private

      def from_http(http)
        headers = http..response_header
        @id                       = headers["ACTIVITYID"]
        @activity_id              = @id
        @status                   = headers.status
        @device_connection_status = headers["X_DEVICECONNECTIONSTATUS"]
        @notification_status      = headers["X_NOTIFICATIONSTATUS"]
        @subscription_status      = headers["X_SUBSCRIPTIONSTATUS"]
        @error                    = success? ? nil : @notification_status
      end

      def from_hash(hash)
        @id           = hash[:id]
        @activity_id  = @id
        @status       = hash[:status]
        @retry_after  = hash[:retry_after]
        @client_auth  = hash[:client_auth]
        @error        = hash[:error]
      end

      def compute_duration(start)
        start && ((Time.now.to_f - start) * 1000.0).round
      end
    end
  end
end
