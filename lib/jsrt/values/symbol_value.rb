module JSRT
  module Values
    # class for Symbol value.
    class SymbolValue < Value

      def type
        :symbol
      end

      def to_ruby
        raise TypeError, 'JavaScript symbol cannot be converted to Ruby value.'
      end
    end
  end
end
