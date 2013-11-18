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
  # match this vendor
  # TODO validation
  lookup = Vendor.new(data)

  # initial query
  query = Vendor.all
  # matching
  # name
  #query = query.all(name: lookup.name)
  # revision
  # vendor verified
  # url
  # status
  query = query.all(status: lookup.status)
  # status since
  # hosting
  query = query.all(hosting: lookup.hosting)
  # pricing
  lookup.pricings.each do |p|
    query = query.and({ 'pricing.model' => p.model }, { 'pricing.period' => p.period })
  end
  # scaling
  if lookup.scaling
    query = query.all('scaling.vertical' => lookup.scaling.vertical)
    query = query.all('scaling.horizontal' => lookup.scaling.horizontal)
    query = query.all('scaling.auto' => lookup.scaling.auto)
  end
  # compliance
  query = query.all(compliance: lookup.compliance)
  # runtimes
  lookup.runtimes.each do |r|
    query = query.all('runtimes.language' => r.language)
  end
  # middleware
  lookup.middlewares.each do |m|
    query = query.all('middleware.name' => m.name)
  end
  # frameworks
  lookup.frameworks.each do |f|
    query = query.all('frameworks.name' => f.name)
  end
  # services
  if lookup.service
    lookup.service.addons.each do |a|
      query = query.all('services.addon.name' => a.name)
    end
    lookup.service.natives.each do |n|
      query = query.all('services.native.name' => n.name)
    end
  end
  # extensibility
  query = query.where(extendable: lookup.extendable) if lookup.extendable
  # infrastructures
  if lookup.infrastructures
    lookup.infrastructures.each do |i|
      query = query.all('infrastructures.continent' => i.continent)
      query = query.all('infrastructures.country' => i.country)
    end
  end

  result = []
  query.each do |d|
    result << d.as_document.as_json
  end

  result.to_json(:except => '_id')

  # TODO check versions on result
  result.each do |r|
    vsupport = false
    r["runtimes"].each do |rt|
      rt["versions"].each do |v|
        v.gsub! "*", "99"
        if Versionomy.parse(v) >= "1.9.3"
          vsupport = true
        end
      end
    end
    result.delete(r) unless vsupport
  end

  result.to_json

end