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