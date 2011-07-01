module EventMachine
  module WPN
    class Toast
      attr_reader :uri, :properties, :uuid

      def initialize(uri, properties)
        @uri = uri
        @properties = properties.symbolize_keys
        @uuid = $uuid.generate
      end

      def body
        @body ||= generate_body
      end

      private

      # TODO Ensure payload is < 1k
      def generate_body
        payload = ""

        payload << "<wp:Text1>#{properties[:text1]}</wp:Text1>" if properties[:text1]
        payload << "<wp:Text2>#{properties[:text2]}</wp:Text2>" if properties[:text2]

        if params = properties[:params]
          params_string = "?#{params.to_query}"
          params_string = "/#{properties[:xaml]}#{params_string}" if properties[:xaml]
          payload << "<wp:Param>#{params_string}</wp:Param>"
        end

        <<-XML
<?xml version="1.0" encoding="utf-8"?>
<wp:Notification xmlns:wp="WPNotification">
  <wp:Toast>#{payload}</wp:Toast>
</wp:Notification>
        XML
      end
    end
  end
end
