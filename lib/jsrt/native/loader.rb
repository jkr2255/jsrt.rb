require 'fiddle'
module JSRT
  module Native
    # Module for loading JSRT libraries.
    module Loader
      # sequentially tries to load library, and return successed library name.
      def try_dlload(*libs)
        libs.each do |lib|
          begin
            dlload lib
            return lib
          rescue Fiddle::DLError
            # do nothing, try next lib
          end
        end
        nil
      end

      LIBRARY_SYMBOLS = {
        default: %w|chakra.dll jscript9.dll|,
        chakra: 'chakra.dll',
        jscript9: 'jscript9.dll'
      }.freeze

      # check if using legacy library (jscript9.dll)
      def legacy?
        @loaded_lib =~ /jscript9(\.dll)?$/i
      end


      TYPE_ALIASES = {
        JsErrorCode: 'unsigned int',
        JsRuntimeHandle: 'void *',
        JsContextRef: 'void *',
        JsValueRef: 'void *',
        JsRef: 'void *',
        JsSourceContext: 'uintptr_t',
        JsValueType: 'int'
      }.freeze

      # common functions for both chakra.dll & jscript9.dll

      COMMON_EXTERNS = [
        # for runtime
        'JsDisposeRuntime(JsRuntimeHandle)',
        'JsGetRuntimeMemoryLimit(JsRuntimeHandle, size_t *)',
        'JsGetRuntimeMemoryUsage(JsRuntimeHandle, size_t *)',
        'JsSetRuntimeMemoryLimit(JsRuntimeHandle, size_t)',
        'JsCollectGarbage(JsRuntimeHandle)',
        # for context
        'JsSetCurrentContext(JsContextRef)',
        'JsRunScript(wchar_t *, JsSourceContext, wchar_t *, JsValueRef *)',
        'JsHasException(char *)',
        'JsGetAndClearException(JsValueRef *)',
        # for variable
        'JsAddRef(JsRef, unsigned int *)',
        'JsRelease(JsRef, unsigned int *)',
        'JsGetValueType(JsValueRef, JsValueType *)',
        'JsBooleanToBool(JsValueRef, char *)',
        'JsNumberToDouble(JsValueRef, double *)',
        'JsGetStringLength(JsValueRef, int *)',
        'JsStringToPointer(JsValueRef, wchar_t **, size_t *)',
        'JsGetPrototype(JsValueRef, JsValueRef *)',
        'JsGetTrueValue(JsValueRef *)',
        'JsGetGlobalObject(JsValueRef *)',
        'JsGetFalseValue(JsValueRef *)',
        'JsGetNullValue(JsValueRef *)',
        'JsGetUndefinedValue(JsValueRef *)',
        'JsDoubleToNumber(double, JsValueRef *)',
        'JsPointerToString(wchar_t *, size_t, JsValueRef *)',
        'JsCallFunction(JsValueRef, JsValueRef *, unsigned short, JsValueRef *)',
        'JsGetIndexedProperty(JsValueRef, JsValueRef, JsValueRef *)',
        'JsSetIndexedProperty(JsValueRef, JsValueRef, JsValueRef)',
        'JsConvertValueToBoolean(JsValueRef, JsValueRef *)',
        'JsConvertValueToNumber(JsValueRef, JsValueRef *)',
        'JsConvertValueToObject(JsValueRef, JsValueRef *)',
        'JsConvertValueToString(JsValueRef, JsValueRef *)',
        'JsEquals(JsValueRef, JsValueRef, char *)'
      ].freeze

      LEGACY_EXTERNS = [
        'JsCreateRuntime(int, int, void *, JsRuntimeHandle *)',
        'JsCreateContext(JsRuntimeHandle, void *, JsContextRef *)'
      ].freeze

      EDGE_EXTERNS = [
        'JsCreateRuntime(int, void *, JsRuntimeHandle *)',
        'JsCreateContext(JsRuntimeHandle, JsContextRef *)'
      ].freeze

      # make JSRT method private
      def extern_jsrt(signature)
        private_class_method extern("JsErrorCode #{signature}", :stdcall).name
      end

      def extern_runtimes
        TYPE_ALIASES.each { |key, val| typealias key.to_s, val }
        COMMON_EXTERNS.each { |signature| extern_jsrt signature }
        diffs = legacy? ? LEGACY_EXTERNS : EDGE_EXTERNS
        diffs.each { |signature| extern_jsrt signature }
      end

      def load_library(lib = :default)
        return if @loaded_lib
        libs = LIBRARY_SYMBOLS.fetch(lib, lib)
        @loaded_lib = try_dlload(*libs)
        raise LoadError, 'Unable to load JSRT library' unless @loaded_lib
        extern_runtimes
      end

    end
  end
end
