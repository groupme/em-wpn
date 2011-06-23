require "spec_helper"

describe EventMachine::WPN do
  describe ".push" do
    before do
      EM::WPN.deliveries.clear
    end

    it "delivers push notification through a simple interface" do
      notification = EM::WPN::Toast.new("http://example.com", :text1 => "Hello world")
      expect {
        EM.run_block do
          EM::WPN.push(notification)
        end
      }.to change { EM::WPN.deliveries.size }.by(1)

      notification = EM::WPN.deliveries.first
      notification.uri.should == "http://example.com"
      notification.properties.should == {:text1 => "Hello world"}
    end
  end
end
