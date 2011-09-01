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
        payload = ""
        payload << "<wp:BackgroundImage>#{properties[:background_image]}</wp:BackgroundImage>" if properties[:background_image]
        payload << "<wp:Count>#{properties[:count]}</wp:Count>" if properties[:count]
        payload << "<wp:Title>#{properties[:title]}</wp:Title>" if properties[:title]

        <<-XML
<?xml version="1.0" encoding="utf-8"?>
<wp:Notification xmlns:wp="WPNotification"><wp:Tile>#{payload}</wp:Tile></wp:Notification>
        XML
      end
    end
  end
end
