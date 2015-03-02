require 'grape'
require 'versionomy'

require_relative 'app/entities/vendor'
require_relative 'app/models/vendor/vendor'
require_relative 'lib/broker/broker'

module Profiles
  class API < Grape::API
    version 'v1', using: :header, vendor: 'paasify'
    format :json
    prefix :api

    resource :vendors do
      desc 'Returns a vendor.'
      params do
        requires :name, type: String, regexp: /^[a-z_]+$/, desc: 'Vendor name.'
      end
      get ':name' do
        begin
          vendor = Vendor.find_by(name: /#{params[:name].gsub('_', ' ')}/i)
          present vendor
        rescue Mongoid::Errors::DocumentNotFound
          error! 'Vendor not found', 404
        end
      end
    end

    post '/broker' do
      begin
        data = JSON.parse(request.body.read)
        # match this vendor
        result = Broker.new.match(data)
        present result
      rescue JSON::ParserError => e
        error! "JSON request has a bad format #{e}", 400
      rescue StandardError => e
        error! "Matching error #{e}", 500
      end
    end
  end
end
