require 'jsrt/values/object_value'
require 'fiddle'
module JSRT
  module Values
    # class for Function value.
    class FunctionValue < ObjectValue

      def to_ruby
        raise TypeError, 'JavaScript function cannot be converted to Ruby value.'
      end

      def type
        :function
      end

      def arg_pointers(val_args)
        pack_str = Fiddle::SIZEOF_VOIDP == 8 ? 'Q*' : 'L*'
        val_args.map { |val| val.handle.to_i }.pack(pack_str)
      end

      private :arg_pointers

      def call(this_arg, *args)
        args.unshift this_arg
        # store Value objects to keep from JSRT's gc
        val_args = args.map { |arg| context.val_to_js(arg) }
        ret_buf = Native.value 'void *'
        context.set_context
        Native.call :JsCallFunction, handle, arg_pointers(val_args), args.length, ret_buf
        return if ret_buf.value.null?
        Value.create context, ret_buf.value
      end
    end
  end
end
