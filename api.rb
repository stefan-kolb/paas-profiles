require 'grape'
require 'versionomy'
require 'geocoder'
require 'cgi'

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

      get ':name/infrastructures' do
        name = CGI::unescape(params[:name])
        # TODO: move to main configuration file
        Geocoder.configure(
            :timeout => 5
        )

        markers = []
        vendor = Vendor.where(name: /#{name}/i).only(:infrastructures).first

        unless vendor['infrastructures'].blank?
          vendor['infrastructures'].each do |infra|
            unless infra['region'].blank?
              begin
                dc = Datacenter.find_by(region: infra['region'], country: infra['country'])
                markers << { latLng: dc.coordinates, name: dc.to_s }
              rescue Mongoid::Errors::DocumentNotFound
                coord = Geocoder.coordinates("#{infra['region']}, #{infra['country']}")
                markers << { latLng: coord, name: infra['region'] }
              end
            end
          end
        end

        markers
      end
    end

    post '/broker' do
      begin
        data = JSON.parse(request.body.read)
        # match this vendor
        result = Broker.new.match(data)
        present result
        status 200
      rescue JSON::ParserError => e
        error! "JSON request has a bad format #{e}", 400
      rescue StandardError => e
        error! "Matching error #{e}", 500
      end
    end

    get '/infrastructures' do
      markers = []

      Datacenter.all.each do |center|
        markers << {latLng: center.coordinates, name: "#{center}"}
      end

      markers
    end
  end
end
