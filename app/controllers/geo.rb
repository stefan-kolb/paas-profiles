
    get '/vendor/:name/infrastructures' do
      name = params[:name]
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
              markers << { latLng: infra['region'], name: coord }
            end
          end
        end
      end

      markers.to_json
    end

    get '/infrastructures' do
      markers = []

      Datacenter.all.each do |center|
        markers << {latLng: center.coordinates, name: "#{center}"}
      end

      markers.to_json
    end
