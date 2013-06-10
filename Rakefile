require "bundler/gem_tasks"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

if ENV["DOC"]
  require 'redcarpet'
  require 'yard'
  require 'yard/rake/yardoc_task'

  YARD::Rake::YardocTask.new do |t|
    t.files   = ['lib/**/*.rb']
  end

  task :default => :yard
end