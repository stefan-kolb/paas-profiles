require 'json'
require 'mongoid'
require 'rake/testtask'
require 'geocoder'
require 'rest-client'
require 'open-uri'

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

Mongoid.load!('./config/mongoid.yml', :test)

# code style
require 'rubocop/rake_task'
RuboCop::RakeTask.new

# tests
Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/test*.rb']
end

task default: [:rubocop, :test]
