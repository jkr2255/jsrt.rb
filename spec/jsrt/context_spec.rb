require 'spec_helper'

describe JSRT::Context do
  let(:context) { JSRT::Context.new }
  let(:context2) { JSRT::Context.new }

  it 'cannot be duplicated' do
    expect { context.dup }.to raise_error(TypeError)
  end

  it 'has #set_context method' do
    expect { context.set_context }.not_to raise_error
  end

  describe '.current' do
    it 'returns current context' do
      context2.set_context
      expect(JSRT::Context.current).to equal context2
      context.set_context
      expect(JSRT::Context.current).to equal context
    end
  end

  describe '#global_obj' do
    it 'returns JavaScript Object' do
      expect(context.global_obj).to be_a JSRT::Values::ObjectValue
    end

    it 'equals "this" in global context' do
      expect(context.global_obj).to eq(context.run_script('this'))
    end
  end

  describe '#run_script' do
    it 'raises JSRT::Error when JavaScript exception is thrown' do
      expect { context.run_script('throw new Error();') }.to raise_error JSRT::Error
    end

    it 'raises JSRT::Error when JavaScript syntax error' do
      expect { context.run_script('var var var;') }.to raise_error JSRT::Error
    end

    it 'can be recovered from JavaScipt error' do
      context.run_script('var var var;') rescue nil
      expect { context.run_script('5 + 3.2') }.not_to raise_error
    end
  end
end
