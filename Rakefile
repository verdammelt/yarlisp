require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['--color', '--format', 'progress' ]
end

desc "Run all specs with RCov"
RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rcov = true
  t.rcov_opts = ['--text-report', '--save', 'coverage.info', '--exclude', 'spec_helper', '--exclude', '^/']
end

desc "Recreate the tags file"
task :tags do
  %x[find . -type f | xargs ctags]
end
desc "Remove tags file"
task :rm_tags do
  File.delete('tags')
end

task :default => [:spec]

