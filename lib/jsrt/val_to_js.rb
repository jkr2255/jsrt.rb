require 'json'
require 'jsrt/native'
module JSRT
  # Ruby value to JavaScript conversion
  module ValToJs

    CONSTANTS = {
      true => :JsGetTrueValue,
      false => :JsGetFalseValue,
      nil => :JsGetNullValue,
      :undefined => :JsGetUndefinedValue
    }.freeze

    TYPE_METHODS = {
      Numeric => :numeric_to_js,
      String => :string_to_js,
      Array => :json_to_js,
      Hash => :json_to_js
    }.freeze

    def val_to_js(val)
      # already JavaScript value
      return val if val.is_a?(Value)
      # constants
      return const_to_js(CONSTANTS[val]) if CONSTANTS[val]
      TYPE_METHODS.each_pair do |klass, sym|
        return send(sym, val) if val.is_a?(klass)
      end
      raise TypeError, 'Type conversion to JavaScript is undefined'
    end

    private

    def const_to_js(sym)
      set_context
      handle_buf = Native.value 'void *'
      Native.call sym, handle_buf
      Value.create self, handle_buf.value
    end

    def numeric_to_js(num)
      set_context
      handle_buf = Native.value 'void *'
      Native.call :JsDoubleToNumber, num.to_f, handle_buf
      Value.create self, handle_buf.value
    end

    def string_to_js(str)
      Value.create self, str2handle(str)
    end

    def json_to_js(obj)
      global_obj.JSON.parse obj.to_json
    end

  end
end
