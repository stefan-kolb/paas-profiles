require 'json'
require 'mongoid'
require 'sinatra'
require 'sinatra/simple-navigation'
require 'versionomy'
require 'newrelic_rpm'

require_relative 'models/vendor'
require_relative 'models/datacenter'
# libs
require_relative 'lib/layout_helper'
require_relative 'lib/breadcrumbs'

# routes
require_relative 'routes/main'
require_relative 'routes/statistics'
require_relative 'routes/api'

Mongoid.load!('./config/mongoid.yml')

set :protection, :except => :frame_options

include LayoutHelper

