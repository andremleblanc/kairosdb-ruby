module KairosDB
  class Client
    attr_reader :config, :writer

    include KairosDB::HTTP
    include KairosDB::Logging
    include KairosDB::Query::Core

    # (see KairosDB::Config#initialize)
    # @example
    #   params = {
    #     host: '172.0.0.1',
    #     port: 8086
    #   }
    #   KairosDB::Client.new(params)
    def initialize(opts = {})
      @config = KairosDB::Config.new(opts)
      @writer = self
      @stopped = false

      at_exit { stop! } if config.retry > 0
    end

    protected

    def stop!
      @stopped = true
    end

    def stopped?
      @stopped
    end
  end
end
