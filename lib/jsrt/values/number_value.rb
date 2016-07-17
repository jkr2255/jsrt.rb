require 'jsrt/value'
module JSRT
  module Values
    # class for Number value.
    class NumberValue < JSRT::Value

      def to_ruby
        return @ruby_val if @ruby_val
        context.set_context
        buf = Native.value('double')
        Native.call :JsNumberToDouble, handle, buf
        @ruby_val = buf.value
      end

      alias to_f to_ruby

      def to_i
        to_ruby.to_i
      end

      def type
        :number
      end

      def ==(other)
        return to_f == other if other.is_a?(Numeric)
        super
      end

      # quack like Numeric

      def <=>(other)
        to_f <=> other
      end

      include Comparable

      def coerce(other)
        [other.to_f, to_f]
      end

      def method_missing(sym, *args)
        if 1.0.respond_to?(sym)
          to_f.send sym, *args
        else
          super
        end
      end

      def respond_to_missing?(symbol, _include_private)
        1.0.respond_to?(symbol)
      end


    end
  end
end
