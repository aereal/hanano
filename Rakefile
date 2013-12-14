require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
end

desc "Run specs and take coverage"
task :coverage => [:prepare_coverage, :spec]
task :prepare_coverage do
  ENV['COVERAGE'] = '1'
end
