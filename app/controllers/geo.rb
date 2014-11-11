get '/vendor/:name/infrastructures' do
  Geocoder.configure(
    :timeout => 5
  )

  markers = []

  vendor = Vendor.where(name: /#{params[:name]}/i).only(:infrastructures).first

  unless vendor['infrastructures'].blank?
    vendor['infrastructures'].each do |infra|
      unless infra['region'].blank?
        begin
          dc = Datacenter.find_by(region: infra['region'], country: infra['country'])
        rescue Mongoid::Errors::DocumentNotFound
          dc = Geocoder.coordinates("#{infra.region}, #{infra.country}")
        end

        markers << { latLng: dc.coordinates, name: dc.to_s } unless dc.blank?
      end
    end
  end

  markers.to_json
end

get '/infrastructures' do
  markers = []

  Datacenter.all.each do |center|
    markers << { latLng: center.coordinates, name: "#{center}" }
  end

  markers.to_json
end