module EventMachine
  module WPN
    class Response
      attr_reader :status,
                  :duration,
                  :activity_id,
                  :device_connection_status,
                  :notification_status,
                  :subscription_status

      def initialize(headers, start)
        @status = headers.status
        @duration = ((Time.now.to_f - start) * 1000.0).round

        @activity_id              = headers["ACTIVITYID"]
        @device_connection_status = headers["X_DEVICECONNECTIONSTATUS"]
        @notification_status      = headers["X_NOTIFICATIONSTATUS"]
        @subscription_status      = headers["X_SUBSCRIPTIONSTATUS"]
      end

      def to_s
        [
          "status:#{status}",
          "subscription:#{subscription_status}",
          "device:#{device_connection_status}",
          "notification:#{notification_status}",
          "activity:#{activity_id}",
          "duration:#{duration}ms"
        ].join(" ")
      end
    end
  end
end
