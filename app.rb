$LOAD_PATH.unshift('lib')

require 'geocoder'
require 'json'
require 'mongoid'
require 'sinatra'
require 'sinatra/simple-navigation'
require 'versionomy'
require 'require_all'

# models
require_all 'app/models'

# views
set :views, Proc.new { File.join(root, 'app/views') }
not_found { erb :'404', :layout => false }
error { erb :'500', :layout => false }

# controllers
require_all 'app/controllers'

# helpers
require_all 'app/helpers'

# configuration
helpers ApplicationHelpers

Mongoid.load!('config/mongoid.yml')

configure :production do
  # monitoring
  require 'newrelic_rpm'
  # protection
  set :protection, :except => :frame_options
end