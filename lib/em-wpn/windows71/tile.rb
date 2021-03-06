module EventMachine
  module WPN
    module Windows71

      # Tile notifications for Windows Phone OS 7.1 apps.
      #
      # MSDN docs: http://msdn.microsoft.com/en-us/library/windowsphone/develop/hh202970(v=vs.105).aspx
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
        #   <wp:Tile>
        #     <wp:Count>999</wp:Count>
        #     <wp:Title>Title</wp:Title>
        #     <wp:BackgroundImage>/image.png</wp:BackgroundImage>
        #
        #     <wp:BackTitle>Dave</wp:BackTitle>
        #     <wp:BackContent>I'm on the back of the tile</wp:BackContent>
        #     <wp:BackBackgroundImage>/background_image.png</wp:BackBackgroundImage>
        #   </wp:Tile>
        # </wp:Notification>
        #
        # If any of the content on the back of the tile is left blank, then those
        # elements are generated with the Action => "Clear" attribute, which should
        # clear them on the tile.
        def generate_body
          builder = Nokogiri::XML::Builder.new(:encoding => "utf-8")

          builder.Notification("xmlns:wp" => "WPNotification") do |notification|
            builder.parent.namespace = builder.parent.namespace_definitions.last

            tile_attributes = properties[:id] ? {"Id" => properties[:id]} : {}

            notification.Tile(tile_attributes) do |tile|
              tile.Count properties[:count] if properties[:count]
              tile.Title properties[:title] if properties[:title]
              tile.BackgroundImage properties[:background_image] if properties[:background_image]

              tile.BackTitle           clear(properties[:back_title])
              tile.BackContent         clear(properties[:back_content])
              tile.BackBackgroundImage clear(properties[:back_background_image])
            end
          end

          builder.to_xml(save_with: NOKOGIRI_SAVE_OPTIONS)
        end
      end

    end
  end
end
