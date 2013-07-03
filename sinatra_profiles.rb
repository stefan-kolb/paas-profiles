require 'sinatra'

get '/vendors' do
	erb :vendors
end

get '/vendor/:name' do
  erb :vendor
end