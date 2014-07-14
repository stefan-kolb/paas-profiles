require 'geocoder'
require 'json'
require 'mongoid'
require 'sinatra'
require 'sinatra/simple-navigation'
require 'versionomy'
require 'rest_client'

# models
require_relative 'models/vendor/vendor'
require_relative 'models/datacenter'

# libs
require_relative 'lib/layout_helper'
require_relative 'lib/breadcrumbs'
require_relative 'lib/feed'

# routes
require_relative 'routes/main'
require_relative 'routes/statistics'
require_relative 'routes/api'

# errors
not_found { erb :'404', :layout => false }
error { erb :'500', :layout => false }

Mongoid.load!('./config/mongoid.yml')

include LayoutHelper

configure :production do
  # monitoring
  require 'newrelic_rpm'
  # protection
  set :protection, :except => :frame_options
end