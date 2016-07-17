module JSRT
  # define constants for JSRT.

  INVALID_REFERENCE = nil

  # rubocop:disable Style/ConstantName

  module RuntimeAttributes
    None                        = 0x00000000
    DisableBackgroundWork       = 0x00000001
    AllowScriptInterrupt        = 0x00000002
    EnableIdleProcessing        = 0x00000004
    DisableNativeCodeGeneration = 0x00000008
    DisableEval                 = 0x00000010
  end

  # module for JSRT error codes.
  module ErrorCode
    NoError                    = 0x00000
    CategoryUsage              = 0x10000
    InvalidArgument            = 0x10001
    NullArgument               = 0x10002
    NoCurrentContext           = 0x10003
    InExceptionState           = 0x10004
    NotImplemented             = 0x10005
    WrongThread                = 0x10006
    RuntimeInUse               = 0x10007
    BadSerializedScript        = 0x10008
    InDisabledState            = 0x10009
    CannotDisableExecution     = 0x1000A
    HeapEnumInProgress         = 0x1000B
    ArgumentNotObject          = 0x1000C
    InProfileCallback          = 0x1000D
    InThreadServiceCallback    = 0x1000E
    CannotSerializeDebugScript = 0x1000F
    AlreadyDebuggingContext    = 0x10010
    AlreadyProfilingContext    = 0x10011
    IdleNotEnabled             = 0x10012
    CategoryEngine             = 0x20000
    OutOfMemory                = 0x20001
    CategoryScript             = 0x30000
    ScriptException            = 0x30001
    ScriptCompile              = 0x30002
    ScriptTerminated           = 0x30003
    ScriptEvalDisabled         = 0x30004
    CategoryFatal              = 0x40000
    Fatal                      = 0x40001

    def self.from_num(num)
      unless @map
        @map = {}
        constants.each { |sym| @map[const_get(sym)] = sym }
      end
      @map[num]
    end
  end

  # Beware of the order!
  TYPES = [
    :undefined, :null, :number, :string, :boolean,
    :object, :function, :error, :array, :symbol
  ].freeze

end
