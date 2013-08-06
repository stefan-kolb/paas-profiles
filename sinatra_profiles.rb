require_relative 'Rakefile'
require_relative 'models/vendor'

require 'mongoid'
require 'sinatra'
require 'newrelic_rpm'

Mongoid.load!("mongoid.yml", :production)

get '/' do
	redirect '/vendors'
end

get '/vendors' do
	@title = "Platform as a Service Profiles"
	erb :vendors
end

get '/vendor/:name' do
	vendor = :name
  @title = "#{params[:name].gsub("_", " ").split(" ").map(&:capitalize).join(" ")} | PaaS Profiles"
	erb :vendor
end

get '/filter' do
	@title = "Find your PaaS | PaaS Profiles"
	erb :filter
end

get '/search' do
	@title = "Search | PaaS Profiles"
	erb :search, :layout => false
end