require 'spec_helper'

describe JSRT do
  it 'has a version number' do
    expect(JSRT::VERSION).not_to be nil
  end

  it 'has #load_library method' do
    expect(JSRT).to respond_to(:load_library)
  end
end
