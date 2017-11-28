require 'grok-pure'

module GrokNGelf
  module Importers
    class Abstract
      attr_reader :helpers

      def initialize(exporter, host, import_id)
        @exporter = exporter
        @import_id = import_id.to_s
        @host = host
        @helpers = Helpers.new
      end

      def import(log)
        raise NotImplementedError
      end

      private

      def set_parser(patterns=[])
        parser = Grok.new
        path = "#{File.dirname(__FILE__)}/../../../patterns"
        (['base'] + patterns).each do |pattern|
          parser.add_patterns_from_file(File.join(path, pattern))
        end
        parser
      end

      def export(data={})
        @exporter.export(LogEvent.new(import_id: @import_id, host: @host, importer: self.class.name, log_file: @log, data: data))
      end

      def update_progress
        print '.'
        $stdout.flush
      end

      def for_matching_lines(log, parser)
        unmatched = StringIO.new

        log = File.open(log, "r") unless log.is_a? StringIO
        log.rewind
        log.each_line do |line|
          match = parser.match(line)
          if match
            update_progress
            yield match.captures
          else
            unmatched.write(line)
          end
        end
        puts "|"
        unmatched
      end

      def dump_unmatched(unmatched)
        return if unmatched.length == 0
        unmatched.rewind
        unmatched.each_line do |line|
          export(
            'timestamp' => Time.now.getutc,
            'program' => 'unmatched',
            'original_line' => line,
            'short_message' => line,
          )
          update_progress
        end
        puts "|"
      end
    end
  end
end
