module EventMachine
  module WPN
    module Windows8

      # Flip Tile notifications for Windows Phone 8.
      #
      # From [MSDN][1]:
      # > The flip Tile template flips from front to back.
      # >
      # > This template is specific to Windows Phone 8.
      #
      # == Properties ==
      #
      # The properties accepted by the initializer are:
      #
      # - id
      # - small_background_image
      # - wide_background_image
      # - wide_back_background_image
      # - wide_back_content
      # - background_image
      # - count
      # - title
      # - back_background_image
      # - back_title
      # - back_content
      #
      # == Example XML Body ==
      #
      #     <?xml version="1.0" encoding="utf-8"?>
      #     <wp:Notification xmlns:wp="WPNotification" Version="2.0">
      #       <wp:Tile Id="" Template="FlipTile">
      #         <wp:SmallBackgroundImage>http://example.com/small_background_image.png</wp:SmallBackgroundImage>
      #         <wp:WideBackgroundImage>http://example.com/wide_background_image.png</wp:WideBackgroundImage>
      #         <wp:WideBackBackgroundImage>http://example.com/wide_back_background_image.png</wp:WideBackBackgroundImage>
      #         <wp:WideBackContent Action="Clear"></wp:WideBackContent>
      #         <wp:BackgroundImage>http://example.com/background_image.png</wp:BackgroundImage>
      #         <wp:Count>10</wp:Count>
      #         <wp:Title>Title</wp:Title>
      #         <wp:BackBackgroundImage>http://example.com/back_background_image.png</wp:BackBackgroundImage>
      #         <wp:BackTitle>Back of tile title</wp:BackTitle>
      #         <wp:BackContent Action="Clear"></wp:BackContent>
      #       </wp:Tile>
      #     </wp:Notification>
      #
      # [1]: http://msdn.microsoft.com/en-us/library/windowsphone/develop/jj206971(v=vs.105).aspx
      #
      class FlipTile < Notification
        def headers
          {
            "X-MessageID"           => uuid,
            "ContentType"           => "text/xml",
            "ContentLength"         => body.size,
            "X-WindowsPhone-Target" => "token",
            "X-NotificationClass"   => "1"
          }
        end

        private

        def generate_body
          builder = Nokogiri::XML::Builder.new(encoding: "utf-8")
          builder.Notification("xmlns:wp" => "WPNotification", "Version" => "2.0") do |notification|
            builder.parent.namespace = builder.parent.namespace_definitions.last
            notification.Tile("Id" => properties[:id], "Template" => "FlipTile") do |tile|
              tile.SmallBackgroundImage    properties[:small_background_image]
              tile.WideBackgroundImage     properties[:wide_background_image]
              tile.WideBackBackgroundImage clear(properties[:wide_back_background_image])
              tile.WideBackContent         clear(properties[:wide_back_content])
              tile.BackgroundImage         properties[:background_image]
              tile.Count                   clear(properties[:count])
              tile.Title                   clear(properties[:title])
              tile.BackBackgroundImage     clear(properties[:back_background_image])
              tile.BackTitle               clear(properties[:back_title])
              tile.BackContent             clear(properties[:back_content])
            end
          end
          builder.to_xml(save_with: NOKOGIRI_SAVE_OPTIONS)
        end
      end

    end
  end
end
