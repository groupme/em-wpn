module EventMachine
  module WPN
    class Client
      def deliver(notification)
        @start = Time.now.to_f
        @http = EventMachine::HttpRequest.new(notification.uri).post(
          :body => notification.body,
          :head => {
            "X-MessageID"           => notification.uuid,
            "ContentType"           => "text/xml",
            "ContentLength"         => notification.body.size,
            "X-WindowsPhone-Target" => "toast",
            "X-NotificationClass"   => "2" # immediate
          }
        )

        @http.callback  { log_success(notification.uuid) }
        @http.errback   { log_failure(notification.uuid) }
      end

      private

      def log_failure(uuid)
        EM::WPN.logger.error("uuid:#{uuid} failed")
      end

      def log_success(uuid)
        time = ((Time.now.to_f - @start) * 1000.0).round
        message = [
          "status:#{@http.response_header.status}",
          "subscription:#{@http.response_header["X_SUBSCRIPTIONSTATUS"]}",
          "device:#{@http.response_header["X_DEVICECONNECTIONSTATUS"]}",
          "notification:#{@http.response_header["X_NOTIFICATIONSTATUS"]}",
          "activity:#{@http.response_header["ACTIVITYID"]}",
          "time:#{time}ms"
        ].join(" ")
        EM::WPN.logger.info("uuid:#{uuid} #{message}")
      end
    end
  end
end
