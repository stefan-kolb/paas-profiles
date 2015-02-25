require './app'
require './app/controllers/api'

run Rack::Cascade.new [Sinatra::Application, Profiles::API]