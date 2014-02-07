require 'spec_helper'

describe Guard::PuppetCheck do

  let(:options) { {} }
  let(:plugin) { Guard::PuppetCheck.new(options) }

  describe "#initialize" do
    describe ":syntax_check option" do
      it "is enabled by default" do
        fresh_plugin = Guard::PuppetCheck.new
        expect(plugin.options[:syntax_check]).to be_true
      end

      it "can be set to false" do
        fresh_plugin = Guard::PuppetCheck.new(syntax_check: false)
        expect(plugin.options[:host]).to be_false
      end
    end

    describe '#start' do
      it "doesn't call #run_all by default" do
        expect(plugin).to_not receive(:run_all)
        plugin.start
      end

      context 'with all_on_start at true' do
        let(:options) { { all_on_start: true } }

        it 'calls #run_all' do
          expect(plugin).to receive(:run_all)
          plugin.start
        end
      end

    end
  end
end