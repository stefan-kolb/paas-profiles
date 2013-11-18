require 'json'
require 'mongoid'
require 'sinatra'
require 'newrelic_rpm'

require_relative 'models/vendor'

Mongoid.load!("./config/mongoid.yml")

get '/' do
	redirect '/vendors'
end

get '/vendors' do
	@title = "Platform as a Service Provider Comparison"
	erb :vendors
end

get '/vendor/:name' do
  @title = "#{params[:name].gsub("_", " ").split(" ").map(&:capitalize).join(" ")} | PaaS Comparison"
	erb :vendor
end

get '/filter' do
	@title = "Find your PaaS | PaaS Comparison"
	erb :filter
end

get '/search' do
	erb :search, :layout => false
end

# api
get '/api/vendor/:vendor' do
  content_type :json
  json = Vendor.find_by(name: /#{params[:vendor].gsub('_', '.')}/i).as_document.to_json(:except => '_id')
end

post '/api/match' do
  data = JSON.parse(request.body.read)
  query = Vendor.all

  if data["hosting"]
    query = query.all(hosting: data["hosting"])
  end

  if data["runtimes"]
    data["runtimes"].each do |r|
        query = query.all("runtimes.language" => r["language"])
        query = query.in("runtimes.versions" => r["versions"])
    end
  end

  if data['services']
    if data['services']['native']

    end
    if data['services']['addon'].each do |a|
        query = query.elem_match('services.addon' => a)
      end
    end
  end

  query.each do |n|
    puts n["name"]
  end
  puts query.count
end