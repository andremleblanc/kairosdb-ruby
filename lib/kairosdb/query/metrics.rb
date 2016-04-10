module KairosDB
  module Query
    module Metrics
      def delete_metric(name)
        url = KairosDB::Query::Core::KAIROSDB_DELETE_PATH + '/' + name
        delete(url)
      end
    end
  end
end
