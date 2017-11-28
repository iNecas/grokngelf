module GrokNGelf
  class LogEvent

    LEVEL = {
      :DEBUG   => 0,
      :INFO    => 1,
      :WARN    => 2,
      :ERROR   => 3,
      :FATAL   => 4,
      :UNKNOWN => 5,
    }

    def initialize(import_id:, host:, importer:, type: nil, log_file:, data:)
      @event = {
          'import_id' => import_id,         # id of the import as set on CLI
          'importer' => importer,           # the importer that produced the event
          'type' => type || importer,           # the importer that produced the event
          'source' => '',                   # hostname of importer machine, *internal*
          'short_message' => '',            # log entry without timestamps, pids, etc.
          'original_line' => '',            # full original log entry
          'timestamp' => Time.now.getutc,   # log event timestamp
          'level' => LEVEL[:DEBUG],         # log level number
          'level_hr' => 'DEBUG',            # log level in human readable format
          'host' => host,                     # source (hostname) of the log entry, set on CLI
          'file' => 'N/A',                  # file the export was called from *internal*
          'line' => 'N/A',                  # line the export was called from *internal*
          'log_file' => log_file,           # file that was parsed to produce this entry
        }.merge(data)
    end

    def timestamp
      timestamp = fetch('timestamp')
      if timestamp.is_a?(Numeric)
        timestamp = Time.at(timestamp).getutc
      end
      timestamp
    end

    def fetch(key, default=nil)
      @event.fetch(key, default)
    end

    def include_data?(data)
      @event.merge(data) == @event
    end

    def inspect
      'Log: ' + @event.inspect
    end

    def to_hash
      @event
    end
  end
end
