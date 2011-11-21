require "spec_helper"

describe EventMachine::WPN do
  describe ".push" do
    it "delivers a push notification through a simple interface" do
      notification = EM::WPN::Toast.new("http://example.com", :text1 => "Hello world")
      request_stub = EM::WPN.stub(notification).to_return(:status => 200)

      EM.run_block do
        EM::WPN.push(notification)
      end

      request_stub.should have_been_requested
    end

    context "when the delivery succeeds" do
      before do
        @notification = EM::WPN::Toast.new("http://example.com", :text1 => "Hello world")
        @request_stub = EM::WPN.stub(@notification).to_return(:status => 200)
      end

      after do
        @request_stub.should have_been_requested
      end

      it "triggers callbacks on the deferrable response" do
        success  = nil
        response = nil

        EM.run_block do
          response = EM::WPN.push(@notification)
        end

        response.callback { success = true  }
        response.errback  { success = false }
        success.should be_true
      end

      it "logs the response" do
        log = StringIO.new
        EM::WPN.logger = Logger.new(log)
        EM.run_block { EM::WPN.push(@notification) }

        log.rewind
        log.read.should include("CODE=200")
      end
    end

    context "when there's an error" do
      before do
        @notification = EM::WPN::Toast.new("http://example.com", :text1 => "Hello world")
        @request_stub = EM::WPN.stub(@notification).to_return(
          :status  => 404,
          :headers => {
            "ACTIVITYID"               => "abc",
            "X_DEVICECONNECTIONSTATUS" => "Disconnected",
            "X_NOTIFICATIONSTATUS"     => "Dropped",
            "X_SUBSCRIPTIONSTATUS"     => "Expired"
          }
        )
      end

      after do
        @request_stub.should have_been_requested
      end

      it "triggers errbacks on the deferrable response" do
        success  = nil
        response = nil

        EM.run_block do
          response = EM::WPN.push(@notification)
        end

        response.callback { success = true  }
        response.errback  { success = false }
        success.should be_false
      end

      it "logs the response" do
        log = StringIO.new
        EM::WPN.logger = Logger.new(log)
        EM.run_block { EM::WPN.push(@notification) }

        log.rewind
        log.read.should include("CODE=404")
      end
    end
  end
end
