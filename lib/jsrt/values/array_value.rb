require 'jsrt/values/object_value'
module JSRT
  module Values
    # class for Array value.
    class ArrayValue < ObjectValue

      def type
        :array
      end

      alias to_a to_ruby

    end
  end
end
