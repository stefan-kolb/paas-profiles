require 'feed'
require 'iso_country_codes'

module Profiles
  class Main < Base

    def url_for(vendor)
      '/vendors/' + vendor
    end

    get '/' do
      redirect to('/vendors')
    end

    get '/terms' do
      @title = 'Terms of Service'
      erb :terms
    end

    get '/success' do
      @title = 'Successful data update'
      erb :success
    end

    get '/vendors' do
      @title = 'Platform as a Service Provider Comparison'
      erb :'profiles/vendors'
    end

    get '/vendors/:name' do
      require_relative '../../lib/version'

      @vendor_path = request.fullpath
      paas = url_decode(params[:name])
      @profile = Vendor.where(name: /^#{paas}$/i).first

      halt 404 if @profile.nil?

      @paas = @profile['name']
      @title = "#{@paas} | PaaS Comparison"

      erb :'profiles/vendor'
    end

    get '/vendors/:name/update' do
      paas = url_decode(params[:name])
      @profile = Vendor.where(name: /^#{paas}$/i).first

      halt 404 if @profile.nil?

      @paas = @profile['name']
      @title = 'Update vendor'

      vendor = params[:name]
      @vendor_path = url_for(vendor)
      @update_vendor_path = url_for(vendor) + '/update'

      erb :'profiles/update'
    end

    get '/vendors/:name/update/review' do
      paas = url_decode(params[:name])
      @profile = Vendor.where(name: /^#{paas}$/i).first

      @paas = @profile['name']
      @title = 'Review of your Update'

      vendor = params[:name]
      @vendor_path = url_for(vendor)
      @update_vendor_path = url_for(vendor) + '/update'
      @review_vendor_path = url_for(vendor) + '/update/review'

      erb :'profiles/review'
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

      halt 404 if @p1.nil? || @p2.nil?

      @title = "#{@p1.name} vs #{@p2.name} | PaaS Comparison"

      erb :'profiles/compare'
    end

    get '/search' do
      erb :'profiles/search', layout: false
    end

    get '/vendors.rss' do
      content_type 'application/rss+xml'
      Feed.rss
    end
  end
end
