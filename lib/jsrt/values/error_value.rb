require 'jsrt/values/object_value'
module JSRT
  module Values
    # class for Error value.
    class ErrorValue < ObjectValue

      def type
        :error
      end

      def name
        self[:name].to_s
      end

      def message
        self[:message].to_s
      end

      def stack
        self[:stack].to_s
      end
    end
  end
end
