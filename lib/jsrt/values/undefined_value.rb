require 'jsrt/value'
module JSRT
  module Values
    # class for undefined value.
    class UndefinedValue < JSRT::Value
      def to_ruby
        :undefined
      end

      def type
        :undefined
      end
    end
  end
end
