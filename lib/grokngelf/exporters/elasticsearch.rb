require 'elasticsearch'

module GrokNGelf
  module Exporters
    class Elasticsearch < Abstract
      def initialize(hostname, port)
        @client = ::Elasticsearch::Client.new(host: "#{hostname}:#{port}", log: true)
        @known_indexes = []
      end

      def export(log_event)
        @client.index(index: index_name(log_event), type: log_event.fetch('type'), body: log_event.to_hash)
      end

      private

      def index_name(log_event)
        "logstash-#{log_event.timestamp.strftime('%Y-%m-%d')}"
      end
    end
  end
end
