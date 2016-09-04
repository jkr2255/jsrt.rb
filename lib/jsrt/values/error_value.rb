require 'jsrt/values/object_value'
module JSRT
  module Values
    # class for Error value.
    class ErrorValue < ObjectValue

      def type
        :error
      end

    end
  end
end
