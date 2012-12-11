require "spec_helper"

describe EM::WPN::Windows8::FlipTile do
  describe "#body" do
    it "builds an XML payload from the passed properties" do
      properties = {
        id:                         "Tile ID",
        small_background_image:     "http://example.com/small_background_image.png",
        wide_background_image:      "http://example.com/wide_background_image.png",
        wide_back_background_image: "http://example.com/wide_back_background_image.png",
        wide_back_content:          "Back of wide tile content",
        background_image:           "http://example.com/background_image.png",
        count:                      10,
        title:                      "Title",
        back_background_image:      "http://example.com/back_background_image.png",
        back_title:                 "Back of tile title",
        back_content:               "Back of medium tile content"
      }

      flip_tile = EM::WPN::Windows8::FlipTile.new("http://example.com", properties)
      flip_tile.body.should == <<XML
<?xml version="1.0" encoding="utf-8"?>
<wp:Notification xmlns:wp="WPNotification" Version="2.0">
  <wp:Tile Id="Tile ID" Template="FlipTile">
    <wp:SmallBackgroundImage>http://example.com/small_background_image.png</wp:SmallBackgroundImage>
    <wp:WideBackgroundImage>http://example.com/wide_background_image.png</wp:WideBackgroundImage>
    <wp:WideBackBackgroundImage>http://example.com/wide_back_background_image.png</wp:WideBackBackgroundImage>
    <wp:WideBackContent>Back of wide tile content</wp:WideBackContent>
    <wp:BackgroundImage>http://example.com/background_image.png</wp:BackgroundImage>
    <wp:Count>10</wp:Count>
    <wp:Title>Title</wp:Title>
    <wp:BackBackgroundImage>http://example.com/back_background_image.png</wp:BackBackgroundImage>
    <wp:BackTitle>Back of tile title</wp:BackTitle>
    <wp:BackContent>Back of medium tile content</wp:BackContent>
  </wp:Tile>
</wp:Notification>
XML
    end
  end

  describe "#headers" do
    it "generates the proper headers" do
      flip_tile = EM::WPN::Windows8::FlipTile.new("http://example.com", {})
      flip_tile.headers.should == {
        "X-MessageID"           => flip_tile.uuid,
        "ContentType"           => "text/xml",
        "ContentLength"         => flip_tile.body.size,
        "X-WindowsPhone-Target" => "token",
        "X-NotificationClass"   => "1"
      }
    end
  end
end
