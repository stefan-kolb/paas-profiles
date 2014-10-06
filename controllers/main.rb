get '/' do
  redirect to('/vendors')
end

get '/vendors' do
  @title = 'Platform as a Service Provider Comparison'
  erb :'profiles/vendors'
end

get '/vendor/:name' do
  require_relative '../lib/version'

  @vendor_path = request.fullpath
  paas = url_decode(params[:name])
  @profile = Vendor.where(name: /^#{paas}$/i).first

  if @profile.nil?
    halt 404
  end

  @paas = @profile['name']
  @title = "#{@paas} | PaaS Comparison"

  erb :'profiles/vendor'
end

get '/filter' do
  @title = 'Find your PaaS | PaaS Comparison'
  erb :'profiles/filter'
end

get '/compare' do
  @versus_path = request.fullpath
  @p1 = Vendor.where(name: /heroku/i).first
  @p2 = Vendor.where(name: /openshift online/i).first
  @title = "#{@p1.name} vs #{@p2.name} | PaaS Comparison"

  erb :'profiles/compare'
end

get '/compare/*-vs-*' do
  @versus_path = request.fullpath
  @p1 = Vendor.where(name: /^#{params[:splat][0]}$/i).first
  @p2 = Vendor.where(name: /^#{params[:splat][1]}$/i).first

  if @p1.nil? || @p2.nil?
    halt 404
  end

  @title = "#{@p1.name} vs #{@p2.name} | PaaS Comparison"

  erb :'profiles/compare'
end

get '/search' do
  erb :'profiles/search', :layout => false
end

get '/vendors.rss' do
  content_type 'application/rss+xml'

  Feed.get_rss
end