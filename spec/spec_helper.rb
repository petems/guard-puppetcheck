require 'coveralls'
Coveralls.wear!

require 'rspec'
require 'guard/puppetcheck'
require 'rspec-given'
require 'capture_helper'

ENV["GUARD_ENV"] = 'test'

RSpec.configure do |config|
  config.color_enabled = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.order = 'random'
end
