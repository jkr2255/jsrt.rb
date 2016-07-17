require 'spec_helper'

describe JSRT::Runtime do

  let(:instance) { JSRT::Runtime.instance }

  it 'cannot be duplicated' do
    expect { instance.dup }.to raise_error(TypeError)
  end

  context '.instance' do
    it 'returns JSRT::Runtime instance' do
      expect(JSRT::Runtime.instance).to be_a(JSRT::Runtime)
    end

    it 'returns the same object within the same thread' do
      expect(JSRT::Runtime.instance).to be instance
    end

    it 'returns different object in different threads' do
      id = nil
      Thread.new { id = JSRT::Runtime.instance.object_id }.join
      expect(JSRT::Runtime.instance.object_id).not_to be id
    end
  end

  context '#handle' do
    it 'returns Fiddle::Pointer' do
      expect(instance.handle).to be_a(Fiddle::Pointer)
    end
  end

  context '#memory_limit' do
    it 'returns Integer' do
      expect(instance.memory_limit).to be_a(Integer)
    end
  end

  context '#memory_limit=' do
    it 'returns Integer' do
      expect(instance.memory_limit = 2**30).to be_a(Integer)
    end

    after :all do
      JSRT::Runtime.instance.memory_limit = -1
    end

  end

  context '#memory_usage' do
    it 'returns Integer' do
      expect(instance.memory_usage).to be_a(Integer)
    end
  end

  context '#run_gc' do
    it 'can be called' do
      expect { instance.run_gc }.not_to raise_error
    end
  end



end
