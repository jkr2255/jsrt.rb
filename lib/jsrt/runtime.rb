require 'jsrt/constants'
module JSRT
  # Wrapper class for JSRT runtime.
  # single instance per Thread.
  class Runtime

    def self.finalize_proc(handle)
      proc do
        Native.call :JsDisposeRuntime, handle.value
      end
    end

    private_class_method :new

    def self.instance
      Thread.current['JSRT::Runtime'] ||= __send__ :new
    end

    def initialize
      @handle_data = Native.create_runtime
      ObjectSpace.define_finalizer self, self.class.finalize_proc(@handle_data)
    end

    def initialize_copy(*)
      raise TypeError, 'JSRT::Runtime cannot be duplicated.'
    end

    def handle
      @handle_data.value
    end

    def memory_limit
      sizet_buf = Native.value('size_t')
      Native.call :JsGetRuntimeMemoryLimit, handle, sizet_buf
      sizet_buf.value
    end

    def memory_usage
      sizet_buf = Native.value('size_t')
      Native.call :JsGetRuntimeMemoryUsage, handle, sizet_buf
      sizet_buf.value
    end

    def memory_limit=(val)
      Native.call :JsSetRuntimeMemoryLimit, handle, val.to_int
    end

    def run_gc
      Native.call :JsCollectGarbage, handle
    end
  end

  def self.runtime
    Runtime.instance
  end
end
