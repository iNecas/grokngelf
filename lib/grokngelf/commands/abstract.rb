module GrokNGelf
  module Commands
    class AbstractCommand < Clamp::Command

      option ['--target', '-t'], 'TARGET', 'machine where we can send the processed logs', :required => true
      option ['--port', '-p'], 'PORT', 'port where we can send the processed logs'
      option ['--protocol'], 'PROTOCOL', 'protocol to use to send the data (applicable for GELF only)', :default => 'TCP'
      # option ['--cut'], :flag, 'remove the processed lines from the log', :default => false
      option ['--host'], 'HOST', 'hostname of the machine the logs originates from (a.k.a facilty)', :default => 'default'
      option ['--import-id'], 'IMPORT_ID', 'unique identification of the import', :default => 1
      option ['--exporter', '-e'], 'EXPORTER', 'Which exporter should be used? One of [gelf (default), elasticsearch]', :default => 'gelf', :attribute_name => 'exporter_type' do |value|
        expected_exporters = %w[gefl elasticsearch]
        raise ArgumentError, "Unexpected exporter #{value}, expected one of #{expected_exporters}" unless expected_exporters.include?(value)
        value.downcase
      end

      def execute
        puts 'Done'
        0
      end

      private

      def get_protocol
        case protocol
        when 'UDP'
          GELF::Protocol::UDP
        when 'TCP'
          GELF::Protocol::TCP
        else
          puts "Unknown protocol #{protocol}. Use either 'UDP' or 'TCP'"
          exit 1
        end
      end

      def exporter
        @exporter ||= case exporter_type
                      when 'gelf'
                        Exporters::Gelf.new(target, port || '12201', get_protocol)
                      when 'elasticsearch'
                        Exporters::Elasticsearch.new(target, port || '9200')
                      end
      end
    end
  end
end
