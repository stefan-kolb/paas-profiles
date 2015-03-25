require 'bundler/setup'
require 'mongoid'

require './web'
require './api'

Mongoid.load!('./config/mongoid.yml')

run Rack::Cascade.new [Profiles::Web, Profiles::API]