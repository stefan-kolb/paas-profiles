require 'bundler/setup'
require 'mongoid'

require './web'
require './api'

Mongoid.load!('./config/mongoid.yml')

# middleware
use Rack::Deflater, include: Rack::Mime::MIME_TYPES.select { |_k, v| v =~ /text|json|javascript|xml/ }.values.uniq

run Rack::Cascade.new [Profiles::Web, Profiles::API]
