get '/vendor/:name/infrastructures' do
  markers = []

  user_location = Geocoder.search(request.ip).first
  user_location = user_location.coordinates unless user_location.nil?
  markers << { latLng: user_location, name: "Yeah, that's you!", style: { fill: 'red' } } unless user_location.nil?

  vendor = Vendor.where(name: /#{params[:name]}/i).only(:infrastructures).first

  unless vendor['infrastructures'].blank?
    vendor['infrastructures'].each do |infra|
      unless infra['region'].blank?
        begin
          dc = Datacenter.find_by(region: infra['region'], country: infra['country'])
        rescue Mongoid::Errors::DocumentNotFound
          dc = Geocoder.coordinates("#{infra.region}, #{infra.country}")
        end

        unless dc.blank?
          unless user_location.blank?
            # speed of light / refraction
            min_latency = (Geocoder::Calculations.distance_between(dc.coordinates, user_location, {:units => :km}) * 2 * 1000 / (299792458 / 1.52) * 1000).round(0)
            name = dc.to_s << " > #{min_latency} ms RTT"
          else
            name = dc
          end

          markers << {latLng: dc.coordinates, name: "#{name}"}
        end
      end
    end
  end

  markers.to_json
end

get '/infrastructures' do
  markers = []

  user_location = Geocoder.search(request.ip).first.coordinates
  markers << { latLng: user_location, name: "Yeah, that's you!", style: { fill: 'red' } } unless user_location.nil?

  Datacenter.all.each do |center|
    markers << { latLng: center.coordinates, name: "#{center}" }
  end

  markers.to_json
end