module GrokNGelf
  module Exporters
    class Abstract
      def export(log_event)
        raise NotImplementedError
      end
    end
  end
end
