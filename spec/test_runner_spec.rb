require_relative './spec_helper'


describe 'running' do
  let(:runner) { CrystalTestHook.new('crystal_command' => 'crystal spec') }

  let(:file) { runner.compile(OpenStruct.new(content: content, test: test, extra: extra)) }
  let(:raw_results) { runner.run!(file) }
  let(:results) { raw_results[0] }

  let(:extra) {''}

  let(:content) do
    '_true = true'
  end

  describe '#run!' do
    context 'on simple passed file' do
      let(:test) do
        <<CRYSTAL
describe "_true" do
    it "is true" do
      _true.should eq true
    end
  end
CRYSTAL
      end

      it { expect(results).to eq([['tests _true is true', :passed, '']]) }
    end
    context 'on simple failed file' do
      let(:test) do
        <<CRYSTAL
describe "_true" do
    it "is true" do
      _true.should eq false
    end
  end
CRYSTAL
      end

      it { expect(results).to eq([['tests _true is true', :failed, "Expected: false\n     got: true"]]) }
    end
  end
end
