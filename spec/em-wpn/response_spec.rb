require 'spec_helper'

describe EM::WPN::Response do
  describe "#success?" do
    it "is true when status is 200" do
      response = EM::WPN::Response.new(
        :status => 200
      )
      response.should be_success
    end

    it "is false when status is not 200" do
      response = EM::WPN::Response.new(
        :status => 400
      )
      response.should_not be_success
    end
  end
end
