require 'rubygems'
require 'bundler/setup'

require 'geocoder'
require 'json'
require 'mongoid'
require 'versionomy'
require 'require_all'
# FIXME: change to sinatra/base when simple-navigation is fixed
require 'sinatra'
require 'sinatra/simple-navigation'

# helpers
require_all 'app/helpers'

module Profiles
  class Base < Sinatra::Base
    register Sinatra::SimpleNavigation

    configure do
      # configuration
      helpers ApplicationHelpers
      # views
      set :views, proc { File.join(root, 'app/views') }
      not_found { erb :'404', :layout => false }
      error { erb :'500', :layout => false }
    end

    configure :production do
      # monitoring
      require 'newrelic_rpm'
      # protection
      set :protection, :except => :frame_options
    end
  end
end