require_relative '../app/models/datacenter'

namespace :geo do

  desc 'Retrieve geo coordinates for all data center locations'
  task datacenter: 'db:seed' do
    # raise errors
    Geocoder.configure(always_raise: :all)

    # delete collection
    Profiles::Datacenter.delete_all

    Profiles::Vendor.where(:infrastructures.nin => [[], nil]).each do |vendor|
      vendor.infrastructures.each do |infra|
        next if infra.region.blank?

        begin
          # get coordinates
          coord = Geocoder.coordinates("#{infra.region}, #{infra.country}")
          # unless coord.blank?
          # save datacenter
          ds = Profiles::Datacenter.where(country: infra.country, region: infra.region).first

          if ds.blank?
            ds = Profiles::Datacenter.new(
              coordinates: coord,
              continent: infra.continent,
              country: infra.country,
              region: infra.region
            )
            if infra.provider.blank?
              ds.provider = []
            else
              ds.provider = [infra.provider]
            end
            ds.save
          else
            ds.provider << infra.provider unless ds.provider.include?(infra.provider) || infra.provider.blank?
            ds.save
          end
          # end
          # dont hit query limit
          sleep(1 / 10.0)
        rescue Geocoder::Error => e
          puts 'Error while retrieving geolocation:'
          puts e.to_s
          sleep(5)
          puts 'Retrying...'
          retry
        end

      end
    end

    file = 'data/geo_datacenter.json'

    File.open(file, 'w') do |f|
      f.write(JSON.pretty_generate JSON.parse(Profiles::Datacenter.all.without(:id).to_json))
    end

    # TODO: test if all are here = count distinct regions, country
  end
end
