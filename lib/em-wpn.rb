require "eventmachine"
require "em-http-request"
require "logger"
require "uuid"
require "nokogiri"

require "em-wpn/core_ext"
require "em-wpn/log_message"
require "em-wpn/notification"
require "em-wpn/response"

require "em-wpn/windows71/toast"
require "em-wpn/windows71/tile"

require "em-wpn/windows8/toast"
require "em-wpn/windows8/iconic_tile"
require "em-wpn/windows8/flip_tile"

$uuid = UUID.new

module EventMachine
  module WPN
    def self.push(notification)
      start = Time.now.to_f

      http = EventMachine::HttpRequest.new(notification.uri).post(
        :body => notification.body,
        :head => notification.headers
      )

      Response.new(http, start).tap do |response|
        LogMessage.new(notification, response)
      end
    end

    def self.logger
      @logger ||= Logger.new(STDOUT)
    end

    def self.logger=(new_logger)
      @logger = new_logger
    end
  end
end
