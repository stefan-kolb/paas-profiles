require 'sinatra'

get '/vendor/:name' do
  erb :vendor
end