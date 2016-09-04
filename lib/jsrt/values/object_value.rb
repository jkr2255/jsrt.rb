require 'jsrt/value'
require 'json'
module JSRT
  module Values
    # class for Object value.
    class ObjectValue < JSRT::Value

      def type
        :object
      end

      def __proto__
        context.set_context
        handle_buf = Native.value 'void *'
        Native.call :JsGetPrototype, handle, handle_buf
        Value.create context, handle_buf.value
      end

      def [](index)
        context.set_context
        index = index.to_s if index.is_a?(::Symbol)
        js_index = context.val_to_js(index)
        handle_buf = Native.value 'void *'
        Native.call :JsGetIndexedProperty, handle, js_index.handle, handle_buf
        Value.create context, handle_buf.value
      end

      def []=(index, value)
        context.set_context
        index = index.to_s if index.is_a?(::Symbol)
        js_index = context.val_to_js(index)
        js_value = context.val_to_js(value)
        Native.call :JsSetIndexedProperty, handle, js_index.handle, js_value.handle
        value
      end

      def call_method(name, *args)
        method = self[name]
        raise TypeError, 'Not a method' unless method.is_a?(FunctionValue)
        method.call self, *args
      end

      def to_ruby
        JSON.parse(context.global_obj.JSON.stringify(self).to_s)
      end

      def respond_to_missing?(sym, _include_private)
        !sym.to_s.end_with?('!', '?')
      end

      def call_or_get(sym, *args)
        # get
        val = self[sym]
        return val if args.empty? && !val.is_a?(FunctionValue)
        val.call(self, *args)
      end

      private :call_or_get

      def method_missing(sym, *args)
        super unless respond_to_missing?(sym, false)
        sym_s = sym.to_s
        if sym_s.end_with?('=')
          # assignment
          self[sym_s[0, -1]] = *args
        else
          call_or_get sym, *args
        end
      end
    end
  end
end
