require "spec_helper"

describe EventMachine::WPN::Windows71::Tile do
  describe "#body" do
    it "builds body for :title, :count, :back_content, :back_title, :background_image, and :back_background_image" do
      notification = EM::WPN::Windows71::Tile.new("http://example.com",
        {
          :count => 5,
          :title => "Hello",
          :back_title => "Dave",
          :back_content => "I'm on the back",
          :background_image => "http://example.com/image.png",
          :back_background_image => "http://example.com/back_image.png"
        }
      )
      notification.body.should == <<-XML
<?xml version="1.0" encoding="utf-8"?>
<wp:Notification xmlns:wp="WPNotification">
  <wp:Tile>
    <wp:Count>5</wp:Count>
    <wp:Title>Hello</wp:Title>
    <wp:BackgroundImage>http://example.com/image.png</wp:BackgroundImage>
    <wp:BackTitle>Dave</wp:BackTitle>
    <wp:BackContent>I'm on the back</wp:BackContent>
    <wp:BackBackgroundImage>http://example.com/back_image.png</wp:BackBackgroundImage>
  </wp:Tile>
</wp:Notification>
XML
    end

    it "sets an id on the tile if it's passed in" do
      notification = EM::WPN::Windows71::Tile.new("http://example.com",
        {
          :id => 1,
          :title => "Hi"
        }
      )
      notification.body.should == <<-XML
<?xml version="1.0" encoding="utf-8"?>
<wp:Notification xmlns:wp="WPNotification">
  <wp:Tile Id="1">
    <wp:Title>Hi</wp:Title>
    <wp:BackTitle Action="Clear"></wp:BackTitle>
    <wp:BackContent Action="Clear"></wp:BackContent>
    <wp:BackBackgroundImage Action="Clear"></wp:BackBackgroundImage>
  </wp:Tile>
</wp:Notification>
XML
    end

    it "sets the 'Action' = 'Clear' attribute on any elements on the back of the tile if they are nil" do
      notification = EM::WPN::Windows71::Tile.new("http://example.com",
        {
          :title => "Hi",
          :back_title => nil,
          :back_content => nil,
          :back_background_image => nil
        }
      )
      notification.body.should == <<-XML
<?xml version="1.0" encoding="utf-8"?>
<wp:Notification xmlns:wp="WPNotification">
  <wp:Tile>
    <wp:Title>Hi</wp:Title>
    <wp:BackTitle Action="Clear"></wp:BackTitle>
    <wp:BackContent Action="Clear"></wp:BackContent>
    <wp:BackBackgroundImage Action="Clear"></wp:BackBackgroundImage>
  </wp:Tile>
</wp:Notification>
XML
    end

    it "also sets 'Action' => 'Clear' on back elements of the tile if they are blank" do
      notification = EM::WPN::Windows71::Tile.new("http://example.com",
        {
          :title => "Hi",
          :back_title => "",
          :back_content => "",
          :back_background_image => ""
        }
      )
      notification.body.should == <<-XML
<?xml version="1.0" encoding="utf-8"?>
<wp:Notification xmlns:wp="WPNotification">
  <wp:Tile>
    <wp:Title>Hi</wp:Title>
    <wp:BackTitle Action="Clear"></wp:BackTitle>
    <wp:BackContent Action="Clear"></wp:BackContent>
    <wp:BackBackgroundImage Action="Clear"></wp:BackBackgroundImage>
  </wp:Tile>
</wp:Notification>
      XML

    end

    it "accepts string keys" do
      notification = EM::WPN::Windows71::Tile.new("http://example.com",
        {
          "count" => 5,
          "title" => "Hello"
        }
      )
      notification.body.should == <<-XML
<?xml version="1.0" encoding="utf-8"?>
<wp:Notification xmlns:wp="WPNotification">
  <wp:Tile>
    <wp:Count>5</wp:Count>
    <wp:Title>Hello</wp:Title>
    <wp:BackTitle Action="Clear"></wp:BackTitle>
    <wp:BackContent Action="Clear"></wp:BackContent>
    <wp:BackBackgroundImage Action="Clear"></wp:BackBackgroundImage>
  </wp:Tile>
</wp:Notification>
XML
    end

    it "properly escapes XML entities" do
      notification = EM::WPN::Windows71::Tile.new("http://www.example.com",
        {
          :title => "Mike & Ike > Now & Later"
        }
      )

      notification.body.should == <<-XML
<?xml version="1.0" encoding="utf-8"?>
<wp:Notification xmlns:wp="WPNotification">
  <wp:Tile>
    <wp:Title>Mike &amp; Ike &gt; Now &amp; Later</wp:Title>
    <wp:BackTitle Action="Clear"></wp:BackTitle>
    <wp:BackContent Action="Clear"></wp:BackContent>
    <wp:BackBackgroundImage Action="Clear"></wp:BackBackgroundImage>
  </wp:Tile>
</wp:Notification>
XML
    end
  end

  describe "headers" do
    it "generates proper headers" do
      notification = EM::WPN::Windows71::Tile.new("http://example.com",
        {
          :count => 5,
          :title => "Hello"
        }
      )
      notification.headers.should == {
        "X-MessageID"           => notification.uuid,
        "ContentType"           => "text/xml",
        "ContentLength"         => notification.body.size,
        "X-WindowsPhone-Target" => "token",
        "X-NotificationClass"   => "1"
      }
    end
  end
end
