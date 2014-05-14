require 'geocoder'
require 'json'
require 'mongoid'
require 'sinatra'
require 'sinatra/simple-navigation'
require 'versionomy'

require 'newrelic_rpm'

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

# protection
set :protection, :except => :frame_options

Mongoid.load!('./config/mongoid.yml')

include LayoutHelper