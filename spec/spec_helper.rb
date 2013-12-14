if ENV['COVERAGE'] == '1'
  require 'simplecov'
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
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
