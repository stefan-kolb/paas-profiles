require './web'
require './api'

run Rack::Cascade.new [Profiles::Web, Profiles::API]