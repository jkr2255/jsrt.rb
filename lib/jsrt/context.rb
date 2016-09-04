require 'jsrt/constants'
require 'jsrt/native'
require 'jsrt/runtime'
require 'jsrt/value'
require 'jsrt/val_to_js'
require 'weakref'
module JSRT
  # JSRT context for executing JavaScript.
  class Context

    def self.finalize_proc
      proc do
        Native.call :JsSetCurrentContext, JSRT::INVALID_REFERENCE
      end
    end

    def initialize(runtime = JSRT::Runtime.instance)
      @handle_data = Native.create_context(runtime)
      # keep runtime at least this context exists
      @runtime = runtime
      set_context
      ObjectSpace.define_finalizer self, self.class.finalize_proc
    end

    def initialize_copy(*)
      raise TypeError, 'JSRT::Context cannot be duplicated.'
    end

    def set_context
      Native.call :JsSetCurrentContext, handle
      # thread-local pointer (not to interfere GC & context release)
      Thread.current['JSRT::Context'] = WeakRef.new self
      nil
    end

    def self.current
      ref = Thread.current['JSRT::Context']
      return unless ref
      return ref.__getobj__ if ref.weakref_alive?
      Thread.current['JSRT::Context'] = nil
    end

    def run_script(source, opts = {})
      set_context
      source = source.encode 'UTF-16LE'
      context_id = opts.fetch(:context_id, object_id)
      source_file = opts.fetch(:source_file, '(JSRT.rb)').encode('UTF-16LE')
      ret_val = Native.value('void *')
      Native.call :JsRunScript, source, context_id, source_file, ret_val
      Value.create self, ret_val.value
    end

    def str2handle(str)
      set_context
      ptr_buf = Native.value 'char *'
      encoded = str.encode 'UTF-16LE'
      Native.call :JsPointerToString, encoded, encoded.length, ptr_buf
      ptr_buf.value
    end

    private :str2handle

    include ValToJs

    def retrieve_exception
      char_buf = Native.value 'char'
      Native.call :JsHasException, char_buf
      return if char_buf == 0
      handle_buf = Native.value 'void *'
      Native.call :JsGetAndClearException, handle_buf
      Value.create self, handle_buf.value
    end

    def global_obj
      set_context
      handle_buf = Native.value 'void *'
      Native.call :JsGetGlobalObject, handle_buf
      Value.create self, handle_buf.value
    end

    def handle
      @handle_data.value
    end
  end
end
