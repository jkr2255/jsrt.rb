require 'jsrt/value'
module JSRT
  module Values
    # class for undefined value.
    class NullValue < JSRT::Value
      def to_ruby
        nil
      end

      def type
        :null
      end
    end
  end
end
