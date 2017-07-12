require 'feed'

module Profiles
  class Main < Base
    get '/' do
      redirect to('/vendors')
    end

    get '/terms' do
      @title = 'Terms of Service'
      erb :terms
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

    get '/filter' do
      @title = 'Find your PaaS | PaaS Comparison'
      erb :'profiles/filter'
    end

    get '/compare' do
      @versus_path = request.fullpath
      @p1 = Vendor.where(name: /heroku/i).first
      @p2 = Vendor.where(name: /pivotal web services/i).first
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

    get '/pricing' do
      require_relative 'price_calculator'
      @title = 'PaaS Pricing Comparison'
      if params.length != 0
        calc = PriceCalculator.new(params)
        @results = calc.calculatePrices()
      end
      erb :pricing
    end

  end
end
