module GrokNGelf
  module Importers
    class SOSReport < GrokNGelf::Importers::Abstract

      def import(log)
        puts "Importing sosreport from [#{log}]..."
        @log = log
        GrokNGelf::Importers::Yum.new(@exporter, @host, @import_id).import(File.join(@log, 'var/log/yum.log'))
        GrokNGelf::Importers::Syslog.new(@exporter, @host, @import_id).import(File.join(@log, 'var/log/messages'))
      end
    end
  end
end
