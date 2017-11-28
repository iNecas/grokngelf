require 'gelf'

module GrokNGelf
  module Exporters
    class Gefl < Abstract
      def initialize(hostname, port, protocol)
        @notifier ||= GELF::Notifier.new(hostname, port, 'WAN', :protocol => protocol)
      end

      def export(log_event)
        @notifier.notify(log_event.to_hash)
      end
    end
  end
end
