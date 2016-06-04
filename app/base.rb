require 'geocoder'
require 'json'
require 'versionomy'
require 'require_all'
require 'sinatra/base'
require 'sinatra/simple-navigation'
SimpleNavigation.config_file_paths << File.join(__dir__, '..', 'config')

# helpers
require_all 'app/helpers'

module Profiles
  class Base < Sinatra::Base
    register Sinatra::SimpleNavigation

    configure do
      helpers ApplicationHelpers

      set :root, proc { File.join(__dir__, '..') }
      set :views, proc { File.join(root, 'app/views') }
      not_found { erb :'404', layout: false }
      error { erb :'500', layout: false }
    end

    configure :production do
      # monitoring
      require 'newrelic_rpm'
      # protection
      set :protection, except: :frame_options
    end
  end
end
