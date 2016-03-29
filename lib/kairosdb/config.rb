module KairosDB
  class Config
    attr_accessor :host, :port, :initial_delay, :max_delay, :open_timeout,
      :read_timeout, :retry

    # @param [Hash]
    # @option opts [String] :host the host url of KairosDB.
    # @option opts [Integer] :port the port KairosDB is accessible on.
    # @option opts [Float] :initial_delay minimum delay before retrying an HTTP connection.
    # @option opts [Float] :max_delay maximum delay before retrying an HTTP connection.
    # @option opts [Float] :write_timeout
    # @option opts [Float] :read_timeout
    # @option opts [Boolean] :retry number of times to retry an HTTP connection, setting this to -1 will cause infinite retries
    def initialize(opts = {})
      @host = opts.fetch(:host, 'localhost')
      @port = opts.fetch(:port, 8080)
      @initial_delay = opts.fetch(:initial_delay, 0.01)
      @max_delay = opts.fetch(:max_delay, 30)
      @open_timeout = opts.fetch(:write_timeout, 5)
      @read_timeout = opts.fetch(:read_timeout, 300)
      @retry = opts.fetch(:retry, 3)
    end
  end
end
