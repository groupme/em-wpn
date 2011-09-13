require "eventmachine"
require "em-http-request"
require "logger"
require "uuid"
require "em-wpn/core_ext"
require "em-wpn/client"
require "em-wpn/notification"
require "em-wpn/response"
require "em-wpn/tile"
require "em-wpn/toast"

$uuid = UUID.new

module EventMachine
  module WPN
    def self.push(notification, &block)
      Client.new(notification).deliver(block)
    end

    def self.logger
      @logger ||= Logger.new(STDOUT)
    end

    def self.logger=(new_logger)
      @logger = new_logger
    end
  end
end
