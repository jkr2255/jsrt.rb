require 'jsrt/constants'
require 'jsrt/native'
module JSRT
  # handles JavaScript value.
  # immutable because it is a value object.
  class Value

    def self.finalize_proc(handle)
      proc do
        Native.call :JsRelease, handle, nil
      end
    end

    def initialize_copy
      raise TypeError, 'JSRT::Value cannot be duplicated.'
    end

    def initialize(context, val_handle)
      @context = context
      @handle = val_handle
      Native.call :JsAddRef, @handle, nil
      ObjectSpace.define_finalizer self, self.class.finalize_proc(@handle)
    end

    attr_reader :context, :handle

    def handle2str(str_handle)
      context.set_context
      ptr_buf = Native.value 'char *'
      size_buf = Native.value 'size_t'
      Native.call :JsStringToPointer, str_handle, ptr_buf, size_buf
      s = ptr_buf.value.to_s(size_buf.value * 2).force_encoding 'UTF-16LE'
      s.encode 'UTF-8'
    end

    private :handle2str

    def self.create(context, val_handle)
      context.set_context
      int_buf = Native.value 'int'
      Native.call :JsGetValueType, val_handle, int_buf
      type = JSRT::TYPES[int_buf.value]
      # support for unknown value
      val_class = type ? Values.const_get("#{type.capitalize}Value") : self
      val_class.new(context, val_handle)
    end

    # done in Ruby semantics
    def to_s
      to_ruby.to_s
    end

    # done in JavaScript semantics
    [:boolean, :number, :string, :object].each do |sym|
      define_method :"to_#{sym}" do
        context.set_context
        handle_buf = Native.value 'void *'
        Native.call :"JsConvertValueTo#{sym.capitalize}",
                    handle,
                    handle_buf
        Value.create context, handle_buf.value
      end
    end

    def ==(other)
      return false unless other.is_a?(Value)
      context.set_context
      bool_buf = Native.value 'char'
      Native.call :JsEquals, handle, other.handle, bool_buf
      bool_buf.value != 0
    end

  end
end

JSRT::TYPES.each do |sym|
  require "jsrt/values/#{sym}_value"
end
