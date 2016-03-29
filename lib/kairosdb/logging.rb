require 'logger'

module KairosDB
  module Logging
    PREFIX = "[KairosDB] "

    class << self
      attr_writer :logger
    end

    def self.logger
      return false if @logger == false
      @logger ||= ::Logger.new(STDERR).tap { |logger| logger.level = Logger::INFO }
    end

    def log(level, message)
      KairosDB::Logging.logger.send(level.to_sym, PREFIX + message) if KairosDB::Logging.logger
    end
  end
end
