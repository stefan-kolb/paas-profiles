require 'json'
require 'mongoid'
require 'rake/testtask'
require 'geocoder'
require 'rest-client'
require 'open-uri'

Mongoid.load!('config/mongoid.yml')

# models
require_relative 'app/models/vendor/vendor'

# helper
require_relative 'lib/io_helper'
include IoHelper

# subtasks
require_relative 'tasks/db'
require_relative 'tasks/assets'
require_relative 'tasks/profiles'
require_relative 'tasks/geo'

# code style
require 'rubocop/rake_task'
RuboCop::RakeTask.new

# tests
Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/test*.rb']
  t.ruby_opts = ['-W1']
end

task default: [:rubocop, :test]
