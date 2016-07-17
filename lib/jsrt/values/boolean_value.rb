require 'jsrt/value'
module JSRT
  module Values
    # class for Boolean value.
    class BooleanValue < JSRT::Value

      def to_ruby
        return @ruby_val unless @ruby_val.nil?
        context.set_context
        buf = Native.value('char')
        Native.call :JsBooleanToBool, handle, buf
        @ruby_val = buf.value != 0
      end

      def type
        :boolean
      end
    end
  end
end
