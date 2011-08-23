module EventMachine
  module WPN
    class Notification
      attr_reader :uri, :properties, :uuid

      def initialize(uri, properties)
        @uri = uri
        @properties = properties.symbolize_keys
        @uuid = $uuid.generate
      end

      # TODO Ensure payload is < 1k
      def body
        @body ||= generate_body
      end

      private

      def generate_body
        raise "implement me"
      end
    end
  end
end
