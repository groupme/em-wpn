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

    it "yields a Response if block given" do
      uri = "http://example.com"
      notification = EM::WPN::Toast.new(uri, :text1 => "Hello world")

      stub_request(:post, uri).with(
        :body     => notification.body,
        :headers  => notification.headers
      ).to_return(
        :status   => 404,
        :headers  => {
          "ACTIVITYID"                => "abc",
          "X_DEVICECONNECTIONSTATUS"  => "Disconnected",
          "X_NOTIFICATIONSTATUS"      => "Dropped",
          "X_SUBSCRIPTIONSTATUS"      => "Expired"

        }
      )

      EM.run_block do
        EM::WPN.push(notification) do |response|
          response.status.should == 404
          response.activity_id.should == "abc"
          response.device_connection_status.should == "Disconnected"
          response.notification_status.should == "Dropped"
          response.subscription_status.should == "Expired"
        end
      end
    end
  end
end
