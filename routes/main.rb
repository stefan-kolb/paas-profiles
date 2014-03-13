get '/' do
  redirect to('/vendors')
end

get '/vendors' do
  @title = 'Platform as a Service Provider Comparison'
  erb :'profiles/vendors'
end

get '/vendor/:name' do
  require_relative '../lib/version'

  @route = request.fullpath
  regex  = params[:name].gsub('_', '[\s\.]')
  regex = Regexp.new(regex, 'i')
  @profile = Vendor.where(name: regex).first

  if @profile.nil?
    halt 404, 'This one PaaSed away!'
  end

  # user info FIXME request limit 10k/h
  @user_location = request.location.coordinates

  @paas = @profile['name']
  @title = "#{@paas} | PaaS Comparison"

  erb :'profiles/vendor'
end

get '/filter' do
  @title = 'Find your PaaS | PaaS Comparison'
  erb :'profiles/filter'
end

get '/search' do
  erb :'profiles/search', :layout => false
end