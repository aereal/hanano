if ENV['COVERAGE'] == '1'
  require 'simplecov'
  require 'coveralls'
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter,
  ]
  SimpleCov.start do
    add_filter '/spec/'
    add_filter '/vendor/bundle/'
  end
end

require "parslet/rig/rspec"

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
end
