require 'spec_helper'

describe JSRT::ValToJs do
  let(:context) { JSRT::Context.new }

  describe '#val_to_js' do
    primitive_expecteds = {
      nil => 'null',
      :undefined => 'undefined',
      true => 'true',
      false => 'false',
      0 => '0',
      'string' => '"string"'
    }

    primitive_expecteds.each do |rb, js|
      it "can convert #{rb.inspect} to JavaScript #{js}" do
        expect(context.val_to_js(rb)).to eq(context.run_script(js))
      end
    end
  end
end
