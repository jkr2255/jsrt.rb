require 'jsrt/constants'
require 'jsrt/runtime'
require 'jsrt/context'
require 'jsrt/native'
require 'jsrt/version'
#
# module for JavaScript runtime (JSRT).
#
module JSRT
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

  # return runtime for current thread.
  def self.runtime
    Runtime.instance
  end

end
