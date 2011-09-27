require 'spec_helper'

describe EM::WPN::LogMessage do
  before do
    @notification = EM::WPN::Notification.new("reg_id", :alert => "hi")
  end

  it "logs to info on success" do
    response = EM::WPN::Response.new(
      :id => "activity_id",
      :status => 200
    )

    EM::WPN.logger.should_receive(:info).with(
      "CODE=200 GUID=#{@notification.uuid} TOKEN=#{@notification.uri} TIME=#{response.duration}"
    )

    EM::WPN::LogMessage.new(@notification, response).log
  end

  it "logs to error on success (with error in payload)" do
    response = EM::WPN::Response.new(
      :id => "activity_id",
      :status => 404,
      :error => "Dropped"
    )

    EM::WPN.logger.should_receive(:error).with(
      "CODE=404 GUID=#{@notification.uuid} TOKEN=#{@notification.uri} TIME=#{response.duration} ERROR=#{response.error}"
    )

    EM::WPN::LogMessage.new(@notification, response).log
  end

  it "logs to error on failure" do
    response = EM::WPN::Response.new(
      :id => "activity_id",
      :status => 503,
      :error => "RetryAfter"
    )

    EM::WPN.logger.should_receive(:error).with(
      "CODE=503 GUID=#{@notification.uuid} TOKEN=#{@notification.uri} TIME=#{response.duration} ERROR=#{response.error}"
    )

    EM::WPN::LogMessage.new(@notification, response).log
  end
end
