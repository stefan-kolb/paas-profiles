require_relative 'Rakefile'

require 'sinatra'

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

get '/search' do
	@title = "Search | PaaS Profiles"
	erb :search, :layout => false
end