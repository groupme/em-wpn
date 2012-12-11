module EventMachine
  module WPN
    class Notification
      NOKOGIRI_SAVE_OPTIONS = Nokogiri::XML::Node::SaveOptions::NO_EMPTY_TAGS | Nokogiri::XML::Node::SaveOptions::FORMAT

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

      # To clear the value for an XML property, the Action attribute is set
      # to "Clear". For example:
      #
      #     <wp:BackTitle Action="Clear"></wp:BackTitle>
      #
      def clear(content)
        if content && content.to_s.size > 0
          content
        else
          {"Action" => "Clear"}
        end
      end
    end
  end
end
