require 'spec_helper'

# Note: EM::HttpClient fires callbacks (sets status to 'succeeded') as long as _any_
# response is received. So 200 OK, 404 Not Found... all trigger success callbacks.
# Error callbacks are run when there are network failures, DNS errors, etc.
#
# The EM::WPN::Response class, however, does not follow that convention. Success
# callbacks are triggered only when the delivery actually succeeds (200 OK), and
# errbacks are run for any non-200 response or network error.

describe EM::WPN::Response do
  describe "deferrable behavior" do
    context "when delivery succeeds" do
      before do
        @response_header = EM::HttpResponseHeader[
          "ACTIVITYID"               => "12345",
          "X_DEVICECONNECTIONSTATUS" => "Connected",
          "X_NOTIFICATIONSTATUS"     => "Received",
          "X_SUBSCRIPTIONSTATUS"     => "Active"
        ]
        @response_header.http_status = "200"

        @http = EM::HttpClient.new(mock(EM::Connection), {})
        @http.stub(:response_header).and_return(@response_header)
      end

      it "fires callbacks" do
        success  = nil
        response = EM::WPN::Response.new(@http)
        response.callback { success = true }
        response.errback  { success = false }

        @http.succeed(@http)
        success.should be_true
      end

      it "reports a duration in milliseconds" do
        now = Time.now.to_f
        Time.stub(:now).and_return(now)

        response = EM::WPN::Response.new(@http, now - 2.0)
        response.duration.should be_nil

        @http.succeed(@http)
        response.duration.should == 2000
      end

      it "sets attributes from the response headers" do
        response = EM::WPN::Response.new(@http)
        response.id.should be_nil

        @http.succeed(@http)
        response.status.should == 200

        response.id.should == @response_header["ACTIVITYID"]
        response.activity_id.should == @response_header["ACTIVITYID"]

        response.device_connection_status.should == @response_header["X_DEVICECONNECTIONSTATUS"]
        response.notification_status.should == @response_header["X_NOTIFICATIONSTATUS"]
        response.subscription_status.should == @response_header["X_SUBSCRIPTIONSTATUS"]
      end

      it "has no error if the status is 200" do
        response = EM::WPN::Response.new(@http)
        response.error.should be_nil

        @http.succeed(@http)
        response.error.should be_nil
      end
    end

    context "when the delivery returns a non-200 response" do
      before do
        @response_header = EM::HttpResponseHeader[
          "ACTIVITYID"               => "12345",
          "X_DEVICECONNECTIONSTATUS" => "Connected",
          "X_NOTIFICATIONSTATUS"     => "Dropped",
          "X_SUBSCRIPTIONSTATUS"     => "Expired"
        ]
        @response_header.http_status = "404"

        @http = EM::HttpClient.new(mock(EM::Connection), {})
        @http.stub(:response_header).and_return(@response_header)
      end

      it "fires errbacks" do
        success  = nil
        response = EM::WPN::Response.new(@http)
        response.callback { success = true }
        response.errback  { success = false }

        @http.succeed(@http) # Why succeed? See the note above.
        success.should be_false
      end

      it "reports a duration in milliseconds" do
        now = Time.now.to_f
        Time.stub(:now).and_return(now)

        response = EM::WPN::Response.new(@http, now - 2.0)
        response.duration.should be_nil

        @http.succeed(@http)
        response.duration.should == 2000
      end

      it "sets attributes from the response headers" do
        response = EM::WPN::Response.new(@http)
        response.id.should be_nil

        @http.succeed(@http)
        response.status.should == 404

        response.id.should == @response_header["ACTIVITYID"]
        response.activity_id.should == @response_header["ACTIVITYID"]

        response.device_connection_status.should == @response_header["X_DEVICECONNECTIONSTATUS"]
        response.notification_status.should == @response_header["X_NOTIFICATIONSTATUS"]
        response.subscription_status.should == @response_header["X_SUBSCRIPTIONSTATUS"]
      end

      it "sets the error to the notification status" do
        response = EM::WPN::Response.new(@http)
        response.error.should be_nil

        @http.succeed(@http)
        response.error.should == "Dropped"
      end
    end

    context "when a network error occurs" do
      before do
        @http = EM::HttpClient.new(mock(EM::Connection), {})
        @http.stub(:error).and_return("unable to resolve server address")
        @http.stub(:response_header).and_return({})
      end

      it "fires errbacks" do
        success  = nil
        response = EM::WPN::Response.new(@http)
        response.callback { success = true }
        response.errback  { success = false }

        @http.fail(@http)
        success.should be_false
      end

      it "reports a duration in milliseconds" do
        now = Time.now.to_f
        Time.stub(:now).and_return(now)

        response = EM::WPN::Response.new(@http, now - 30.0)
        response.duration.should be_nil

        @http.fail(@http)
        response.duration.should == 30_000
      end

      it "does not set any attributes (no response headers)" do
        response = EM::WPN::Response.new(@http)
        @http.fail(@http)
        response.status.should be_nil
        response.id.should be_nil
        response.activity_id.should be_nil
      end

      it "sets the error to the response error" do
        response = EM::WPN::Response.new(@http)
        response.error.should be_nil

        @http.fail(@http)
        response.error.should == "unable to resolve server address"
      end
    end
  end
end
