require 'fiddle/import'
require 'jsrt/constants'
require 'jsrt/runtime'
require 'jsrt/context'
require 'jsrt/native/loader'
require 'jsrt/version'
#
# module for JavaScript runtime (JSRT).
#
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

  # Exception from JSRT.
  class Error < ::StandardError

    ERROR_CLASSSES = Hash.new(self).tap do |h|
    end

    def initialize(code)
      @error_code = code
      @error_obj = Context.current.retrieve_exception if Context.current
    end

    def to_s
      code_hex = @error_code.to_s(16)
      code_name = ErrorCode.from_num(@error_code)
      s = "JSRT Error (code = 0x#{code_hex}: JSRT::ErrorCode::#{code_name})"
      s << "\nJavaScript Exception #{@error_obj.name}: #{@error_obj.message}" if @error_obj
      s
    end

    def self.raise_if_error(ret)
      return if ret == ErrorCode::NoError
      raise ERROR_CLASSSES[ret].new(ret)
    end

    attr_reader :error_code, :error_obj
  end

  class LoadError < ::StandardError; end

  # select loading library
  def self.load_library(lib)
    Native.load_library lib
  end

end
