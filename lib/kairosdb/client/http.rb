module KairosDB
  module HTTP
    def post(url, data)
      headers = { 'Content-Type' => 'application/json' }
      connect_with_retry do |http|
        response = do_request http, Net::HTTP::Post.new(url, headers), JSON.generate(data)
        if response.is_a? Net::HTTPSuccess
          handle_successful_response(response)
        else
          resolve_error(response)
        end
      end
    end

    private

    def connect_with_retry(&block)
      host = config.host
      delay = config.initial_delay
      retry_count = 0

      begin
        http = Net::HTTP.new(host, config.port)
        http.open_timeout = config.open_timeout
        http.read_timeout = config.read_timeout

        block.call(http)

      rescue Timeout::Error, *KairosDB::NET_HTTP_EXCEPTIONS => e
        retry_count += 1
        if (config.retry == -1 || retry_count <= config.retry) && !stopped?
          log :error, "Failed to contact host #{host}: #{e.inspect} - retrying in #{delay}s."
          sleep delay
          delay = [config.max_delay, delay * 2].min
          retry
        else
          raise KairosDB::ConnectionError, "Tried #{retry_count - 1} times to reconnect but failed."
        end
      ensure
        http.finish if http.started?
      end
    end

    def do_request(http, req, data = nil)
      req.body = data if data
      http.request(req)
    end

    def errors_from_response(parsed_response)
      parsed_response.is_a?(Hash) && parsed_response.fetch('errors', nil)
    end

    def handle_successful_response(response)
      parsed_response(response)
    end

    def parsed_response(response)
      response.body ? JSON.parse(response.body) : response
    end

    def resolve_error(response)
      parsed_response = parsed_response(response)
      errors = errors_from_response(parsed_response) if parsed_response
      raise KairosDB::QueryError, errors if errors
      raise KairosDB::Error, response
    end

    def config
      raise NotImplementedError, "This #{self.class} cannot respond to ##{__method__}"
    end

    def log(level, message)
      raise NotImplementedError, "This #{self.class} cannot respond to ##{__method__}"
    end

    def stopped?
      raise NotImplementedError, "This #{self.class} cannot respond to ##{__method__}"
    end
  end
end
