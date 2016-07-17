require 'jsrt/value'
module JSRT
  module Values
    # class for String value.
    class StringValue < JSRT::Value
      def to_ruby
        # freeze as JavaScript string is immutable
        @ruby_value ||= handle2str(handle).freeze
      end

      def type
        :string
      end

      def to_i
        to_ruby.to_i
      end

      def to_f
        to_ruby.to_f
      end

      def ==(other)
        return to_ruby == other if other.is_a?(String)
        super
      end

      # quack like String

      alias to_str to_ruby

      def <=>(other)
        to_ruby <=> other
      end

      include Comparable

      def method_missing(sym, *args)
        if 'a'.respond_to?(sym)
          to_ruby.send sym, *args
        else
          super
        end
      end

      def respond_to_missing?(symbol, _include_private)
        'a'.respond_to?(symbol)
      end

    end
  end
end
