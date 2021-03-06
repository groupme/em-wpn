require "spec_helper"

describe EventMachine::WPN::Windows71::Toast do
  describe "#body" do
    it "handles text1 and text2" do
      notification = EM::WPN::Windows71::Toast.new("http://example.com",
        {
          :text1 => "Hello",
          :text2 => "World"
        }
      )
      notification.body.should == <<-XML
<?xml version="1.0" encoding="utf-8"?>
<wp:Notification xmlns:wp="WPNotification">
  <wp:Toast>
    <wp:Text1>Hello</wp:Text1>
    <wp:Text2>World</wp:Text2>
  </wp:Toast>
</wp:Notification>
XML
    end

    it "accepts string keys" do
      notification = EM::WPN::Windows71::Toast.new("http://example.com",
        {
          "text1" => "Hello",
          "text2" => "World"
        }
      )
      notification.body.should == <<-XML
<?xml version="1.0" encoding="utf-8"?>
<wp:Notification xmlns:wp="WPNotification">
  <wp:Toast>
    <wp:Text1>Hello</wp:Text1>
    <wp:Text2>World</wp:Text2>
  </wp:Toast>
</wp:Notification>
XML
    end

    it "handles params" do
      notification = EM::WPN::Windows71::Toast.new("http://example.com",
        {
          :text1  => "Hello",
          :text2  => "World",
          :params => {:foo => "bar", :biz => "baz"}
        }
      )
      notification.body.should == <<-XML
<?xml version="1.0" encoding="utf-8"?>
<wp:Notification xmlns:wp="WPNotification">
  <wp:Toast>
    <wp:Text1>Hello</wp:Text1>
    <wp:Text2>World</wp:Text2>
    <wp:Param>?biz=baz&amp;foo=bar</wp:Param>
  </wp:Toast>
</wp:Notification>
XML
    end

    it "handles params with xaml" do
      notification = EM::WPN::Windows71::Toast.new("http://example.com",
        {
          :text1  => "Hello",
          :text2  => "World",
          :params => {:foo => "bar", :biz => "baz"},
          :xaml   => "page.xaml"
        }
      )
      notification.body.should == <<-XML
<?xml version="1.0" encoding="utf-8"?>
<wp:Notification xmlns:wp="WPNotification">
  <wp:Toast>
    <wp:Text1>Hello</wp:Text1>
    <wp:Text2>World</wp:Text2>
    <wp:Param>/page.xaml?biz=baz&amp;foo=bar</wp:Param>
  </wp:Toast>
</wp:Notification>
XML
    end

    it "sets the wp:Param element when the :param property is present" do
      notification = EM::WPN::Windows71::Toast.new("http://example.com",
        {
          :text1 => "Hello",
          :text2 => "World",
          :param => "/page.xaml?id=1"
        }
      )
      notification.body.should == <<-XML
<?xml version="1.0" encoding="utf-8"?>
<wp:Notification xmlns:wp="WPNotification">
  <wp:Toast>
    <wp:Text1>Hello</wp:Text1>
    <wp:Text2>World</wp:Text2>
    <wp:Param>/page.xaml?id=1</wp:Param>
  </wp:Toast>
</wp:Notification>
XML
    end
  end

  describe "headers" do
    it "generates proper headers" do
      notification = EM::WPN::Windows71::Toast.new("http://example.com",
        {
          :text1 => "Hello",
          :text2 => "World"
        }
      )
      notification.headers.should == {
        "X-MessageID"           => notification.uuid,
        "ContentType"           => "text/xml",
        "ContentLength"         => notification.body.size,
        "X-WindowsPhone-Target" => "toast",
        "X-NotificationClass"   => "2"
      }
    end
  end

end
