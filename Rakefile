require 'bundler'
include Rake::DSL
Bundler::GemHelper.install_tasks

require "rspec/core/rake_task" # RSpec 2.0

RSpec::Core::RakeTask.new(:unit) do |spec|
  #spec.pattern  = 'spec/*/*_spec.rb'
  spec.pattern = 'spec/unit/*_spec.rb'
  spec.rspec_opts = ['--backtrace']
end

RSpec::Core::RakeTask.new(:all) do |spec|
  spec.pattern = 'spec/*/*_spec.rb'
end

# this is for running tests that you've marked current...  eg:  it 'should work', :current => true do
RSpec::Core::RakeTask.new(:current) do |spec|
  spec.pattern = 'spec/*/*_spec.rb'
  spec.rspec_opts = ['--tag current']
end


task :default => :all