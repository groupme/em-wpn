require "spec_helper"

describe EM::WPN::Windows8::IconicTile do
  describe "#body" do
    it "builds an XML payload from the passed properties" do
      properties = {
        small_icon_image: "http://example.com/small_icon_image.png",
        icon_image:       "http://example.com/icon_image.png",
        wide_content_1:   "1st row of content",
        wide_content_2:   "2nd row of content",
        wide_content_3:   "3rd row of content",
        id:               "Tile ID",
        count:            10,
        title:            "Title",
        background_color: "#FF524742"
      }

      iconic_tile = EM::WPN::Windows8::IconicTile.new("http://example.com", properties)
      iconic_tile.body.should == <<XML
<?xml version="1.0" encoding="utf-8"?>
<wp:Notification xmlns:wp="WPNotification" Version="2.0">
  <wp:Tile Id="Tile ID" Template="IconicTile">
    <wp:SmallIconImage>http://example.com/small_icon_image.png</wp:SmallIconImage>
    <wp:IconImage>http://example.com/icon_image.png</wp:IconImage>
    <wp:WideContent1>1st row of content</wp:WideContent1>
    <wp:WideContent2>2nd row of content</wp:WideContent2>
    <wp:WideContent3>3rd row of content</wp:WideContent3>
    <wp:Count>10</wp:Count>
    <wp:Title>Title</wp:Title>
    <wp:BackgroundColor>#FF524742</wp:BackgroundColor>
  </wp:Tile>
</wp:Notification>
XML
    end

    it "properly clears empty properties" do
      iconic_tile = EM::WPN::Windows8::IconicTile.new("http://example.com", {})
      iconic_tile.body.should == <<XML
<?xml version="1.0" encoding="utf-8"?>
<wp:Notification xmlns:wp="WPNotification" Version="2.0">
  <wp:Tile Id="" Template="IconicTile">
    <wp:SmallIconImage Action="Clear"></wp:SmallIconImage>
    <wp:IconImage Action="Clear"></wp:IconImage>
    <wp:WideContent1 Action="Clear"></wp:WideContent1>
    <wp:WideContent2 Action="Clear"></wp:WideContent2>
    <wp:WideContent3 Action="Clear"></wp:WideContent3>
    <wp:Count Action="Clear"></wp:Count>
    <wp:Title Action="Clear"></wp:Title>
    <wp:BackgroundColor Action="Clear"></wp:BackgroundColor>
  </wp:Tile>
</wp:Notification>
XML
    end
  end

  describe "#headers" do
    it "generates the proper headers" do
      iconic_tile = EM::WPN::Windows8::IconicTile.new("http://example.com", {})
      iconic_tile.headers.should == {
        "X-MessageID"           => iconic_tile.uuid,
        "ContentType"           => "text/xml",
        "ContentLength"         => iconic_tile.body.size,
        "X-WindowsPhone-Target" => "token",
        "X-NotificationClass"   => "1"
      }
    end
  end
end
