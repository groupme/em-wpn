require 'spec_helper'

describe EM::WPN::LogMessage do
  before do
    @notification = EM::WPN::Notification.new("reg_id", :alert => "hi")
    @notification.stub(:body).and_return("BODY")
  end

  it "logs to info on success" do
    response = EM::WPN::Response.new(EM::DefaultDeferrable.new)
    response.stub(:duration).and_return(100)
    response.stub(:status).and_return(200)

    EM::WPN.logger.should_receive(:info).with(
      "CODE=200 GUID=#{@notification.uuid} TOKEN=#{@notification.uri} TIME=#{response.duration}"
    )

    EM::WPN::LogMessage.new(@notification, response)
    response.succeed(response)
  end

  it "logs to error on failure" do
    response = EM::WPN::Response.new(EM::DefaultDeferrable.new)
    response.stub(:duration).and_return(100)
    response.stub(:status).and_return(404)
    response.stub(:error).and_return("Dropped")

    EM::WPN.logger.should_receive(:error).with(
      "CODE=404 GUID=#{@notification.uuid} TOKEN=#{@notification.uri} TIME=#{response.duration} ERROR=#{response.error}"
    )

    EM::WPN::LogMessage.new(@notification, response)
    response.fail(response)
  end
end
