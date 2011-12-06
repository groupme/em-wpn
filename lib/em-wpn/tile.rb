module EventMachine
  module WPN
    class Tile < Notification
      def headers
        {
          "X-MessageID"           => uuid,
          "ContentType"           => "text/xml",
          "ContentLength"         => body.size,
          "X-WindowsPhone-Target" => "token",
          "X-NotificationClass"   => "1"
        }
      end

      # <?xml version="1.0" encoding="utf-8"?>
      # <wp:Notification xmlns:wp="WPNotification">
      # <wp:Tile>
      # <wp:BackgroundImage>/image.png</wp:BackgroundImage>
      # <wp:Count>999</wp:Count>
      # <wp:Title>Title</wp:Title>
      # </wp:Tile>
      # </wp:Notification>
      def generate_body
        builder = Nokogiri::XML::Builder.new(:encoding => "utf-8")

        builder.Notification("xmlns:wp" => "WPNotification") do |notification|
          builder.parent.namespace = builder.parent.namespace_definitions.last

          notification.Tile do |tile|
            if properties[:background_image]
              tile.BackgroundImage properties[:background_image]
            end

            tile.Count properties[:count] if properties[:count]
            tile.Title properties[:title] if properties[:title]
          end
        end

        builder.to_xml
      end
    end
  end
end
