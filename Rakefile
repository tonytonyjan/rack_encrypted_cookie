# frozen_string_literal: true
require 'rubocop/rake_task'
require 'rake/testtask'
require 'rake/packagetask'
require 'rubygems/package_task'

desc 'Run linter and tests'
task default: %i(rubocop test)

RuboCop::RakeTask.new

Rake::TestTask.new do |t|
  t.test_files = FileList['test/spec*.rb']
  t.verbose = true
end

spec_path = File.expand_path('../rack_encrypted_cookie.gemspec', __FILE__)
spec = Gem::Specification.load(spec_path)
Gem::PackageTask.new(spec).define
