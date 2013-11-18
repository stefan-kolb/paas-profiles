require 'json'
require 'mongoid'
require 'sinatra'
require 'versionomy'
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
  # match this vendor TODO validation
  lookup = Vendor.new(data)

  query = Vendor.all

  query = query.all(hosting: lookup.hosting)
  query = query.all(status: lookup.status)

  if data["runtimes"]
    data["runtimes"].each do |r|
        query = query.all("runtimes.language" => r["language"])
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

  # check versions on result
  query.each do |r|
    vsupport = false
    if r["runtimes"].each do |rt|
      rt["versions"].each do |v|
        v.gsub! "*", "99"
        if Versionomy.parse(v) >= "1.9.3"
          vsupport = true
        end
      end
    end
    end
    query.to_a.delete r unless vsupport
  end

  puts query.count
end