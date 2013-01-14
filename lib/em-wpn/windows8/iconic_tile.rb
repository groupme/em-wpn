module EventMachine
  module WPN
    module Windows8

      # Iconic Tile notifications for Windows Phone 8.
      #
      # From [MSDN][1]:
      # > The iconic template displays a small image in the center of the
      # > Tile, and incorporates Windows Phone design principles.
      # >
      # > This template is specific to Windows Phone 8.
      #
      # == Properties ==
      #
      # The properties accepted by the initializer are:
      #
      # - small_icon_image
      # - icon_image
      # - wide_content_1
      # - wide_content_2
      # - wide_content_3
      # - id
      # - count
      # - title
      # - background_color
      #
      # == Example XML Body ==
      #
      #     <?xml version="1.0" encoding="utf-8"?>
      #     <wp:Notification xmlns:wp="WPNotification" Version="2.0">
      #       <wp:Tile Id="" Template="IconicTile">
      #         <wp:SmallIconImage>http://example.com/small_icon_image.png</wp:SmallIconImage>
      #         <wp:IconImage>http://example.com/icon_image.png</wp:IconImage>
      #         <wp:WideContent1>1st row of content</wp:WideContent1>
      #         <wp:WideContent2>2nd row of content</wp:WideContent2>
      #         <wp:WideContent3 Action="Clear"></wp:WideContent3>
      #         <wp:Count>10</wp:Count>
      #         <wp:Title>Title</wp:Title>
      #         <wp:BackgroundColor>#FF524742</wp:BackgroundColor>
      #       </wp:Tile>
      #     </wp:Notification>
      #
      # [1]: http://msdn.microsoft.com/en-us/library/windowsphone/develop/jj207009(v=vs.105).aspx
      #
      class IconicTile < Notification
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
            notification.Tile("Id" => properties[:id], "Template" => "IconicTile") do |tile|
              tile.SmallIconImage  properties[:small_icon_image]
              tile.IconImage       properties[:icon_image]
              tile.WideContent1    clear(properties[:wide_content_1])
              tile.WideContent2    clear(properties[:wide_content_2])
              tile.WideContent3    clear(properties[:wide_content_3])
              tile.Count           clear(properties[:count])
              tile.Title           clear(properties[:title])
              tile.BackgroundColor clear(properties[:background_color])
            end
          end
          builder.to_xml(save_with: NOKOGIRI_SAVE_OPTIONS)
        end
      end

    end
  end
end
