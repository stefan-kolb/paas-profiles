require 'json'
require 'mongoid'
require 'sinatra'
require 'versionomy'
require 'newrelic_rpm'
require 'sinatra/simple-navigation'

require_relative 'models/vendor'
require_relative 'lib/breadcrumbs'

Mongoid.load!("./config/mongoid.yml")

set :protection, :except => :frame_options

# routes
require_relative 'routes/main'
require_relative 'routes/statistics'
require_relative 'routes/api'