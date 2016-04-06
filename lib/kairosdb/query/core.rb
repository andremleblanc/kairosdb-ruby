require 'json'

module KairosDB
  module Query
    module Core
      KAIROSDB_QUERY_PATH = '/api/v1/datapoints/query'
      KAIROSDB_WRITE_PATH = '/api/v1/datapoints'

      # @param [Hash] opts
      def query(opts = {})
        url = full_path(KAIROSDB_QUERY_PATH)
        metrics = fetch_metrics(post(url, opts))

        if block_given?
          metrics.each do |metric|
            yield metric['name'], metric['tags'], metric['values']
          end
        else
          metrics
        end
      end

      # @param [Hash] opts
      # @option opts [String] :name name of the measurement being recorded
      # @option opts [Array<Integer, Numeric>] :datapoints one or many points to be recorded
      # @option opts [Hash] :tags a hash of tags for the data points
      def write_data(data)
        writer.write(data)
      end

      protected

      def write(data)
        url = full_path(KAIROSDB_WRITE_PATH)
        post(url, data)
      end

      private

      def fetch_metrics(response)
        response.
          fetch('queries', []).
          fetch(0, []).
          fetch('results', [])
      end

      def full_path(path, params = {})
        query = params.map { |k, v| [CGI.escape(k.to_s), "=", CGI.escape(v.to_s)].join }.join("&")
        URI::Generic.build(path: path, query: query).to_s
      end

      def config
        raise NotImplementedError, "This #{self.class} cannot respond to ##{__method__}"
      end

      def writer
        raise NotImplementedError, "This #{self.class} cannot respond to ##{__method__}"
      end
    end
  end
end
