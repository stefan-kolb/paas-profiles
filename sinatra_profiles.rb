require_relative 'Rakefile'

require 'sinatra'
require 'mongoid'

Mongoid.load!("mongoid.yml", :development)

get '/vendors' do
	@title = "Overview | PaaS Profiles"
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