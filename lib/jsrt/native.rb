require 'jsrt/native/loader'
require 'fiddle/import'
module JSRT
  # module linked to Chakra DLL.
  module Native
    extend Fiddle::Importer
    extend Loader

    # support for functions with different signature
    # return with return value, for simplifying handling
    def self.create_runtime(attributes = RuntimeAttributes::None, callback = nil)
      load_library
      handle_buf = Native.value('void *')
      if legacy?
        Native.call :JsCreateRuntime, attributes, -1, callback, handle_buf
      else
        Native.call :JsCreateRuntime, attributes, callback, handle_buf
      end
      handle_buf
    end

    def self.create_context(runtime)
      handle_buf = Native.value('void *')
      if legacy?
        Native.call :JsCreateContext, runtime.handle, nil, handle_buf
      else
        Native.call :JsCreateContext, runtime.handle, handle_buf
      end
      handle_buf
    end

    # calling native functions
    def self.call(name, *args)
      load_library
      ret = __send__(name, *args)
      JSRT::Error.raise_if_error(ret)
    end
  end
end
