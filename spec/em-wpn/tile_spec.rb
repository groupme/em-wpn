require "spec_helper"

describe EventMachine::WPN::Tile do
  describe "#body" do
    it "builds body for title, count" do
      notification = EM::WPN::Tile.new("http://example.com",
        {
          :count => 5,
          :title => "Hello"
        }
      )
      notification.body.should == <<-XML
<?xml version="1.0" encoding="utf-8"?>
<wp:Notification xmlns:wp="WPNotification"><wp:Tile><wp:Count>5</wp:Count><wp:Title>Hello</wp:Title></wp:Tile></wp:Notification>
XML
    end


    it "builds body for background image" do
      notification = EM::WPN::Tile.new("http://example.com",
        {
          :background_image => "/image.png",
          :title => "Hello"
        }
      )
      notification.body.should == <<-XML
<?xml version="1.0" encoding="utf-8"?>
<wp:Notification xmlns:wp="WPNotification"><wp:Tile><wp:BackgroundImage>/image.png</wp:BackgroundImage><wp:Title>Hello</wp:Title></wp:Tile></wp:Notification>
XML
    end

    it "accepts string keys" do
      notification = EM::WPN::Tile.new("http://example.com",
        {
          "count" => 5,
          "title" => "Hello"
        }
      )
      notification.body.should == <<-XML
<?xml version="1.0" encoding="utf-8"?>
<wp:Notification xmlns:wp="WPNotification"><wp:Tile><wp:Count>5</wp:Count><wp:Title>Hello</wp:Title></wp:Tile></wp:Notification>
XML
    end
  end

  describe "headers" do
    it "generates proper headers" do
      notification = EM::WPN::Tile.new("http://example.com",
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
