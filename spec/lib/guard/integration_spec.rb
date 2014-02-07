require 'spec_helper'

describe Guard::PuppetCheck do
  include CaptureHelper

  Given(:guard){ Guard::PuppetCheck.new(options) }
  Given(:options){ Hash.new }

  context '#run_on_change' do
    Given(:paths){ ["spec/test_files/#{file}.pp"] }
    When(:output) { capture(:stdout) { guard.run_on_change(paths) } }

    context 'with no options' do
      context 'foo file (pass parse, fails lint)' do
        Given(:file) {'foo'}
        Then { output.should include('')}
      end

      context 'foo file (fail parse, fails lint)' do
        Given(:file) {'bar'}
        Then { output.should include('')}
      end

    end

  end

  context '#run_all' do
    context 'with "run_all_dir" option' do
      Given(:options){ {run_all_dir: 'spec/test_files'} }
      When(:output) { capture(:stdout) { guard.run_all } }
      Then { output.should include('')}      
    end
  end
end