require_relative '../models/datacenter'

namespace :geo do

  desc 'Retrieve geo coordinates for all data center locations'
  task :datacenter => 'db:seed'  do
    # raise errors
    Geocoder.configure(:always_raise => :all)

    # delete collection
    Datacenter.delete_all

    Vendor.where(:infrastructures.nin => [[], nil]).each do |vendor|
      vendor.infrastructures.each do |infra|
        unless infra.region.blank?
          begin
            # get coordinates
            coord = Geocoder.coordinates("#{infra.region}, #{infra.country}")
            unless coord.blank?
              # save datacenter
              ds = Datacenter.where(country: infra.country, region: infra.region).first

              if ds.blank?
                ds = Datacenter.new(
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
            end
            # dont hit query limit
            sleep(1/10.0)
          rescue Geocoder::Error => e
            puts 'Error while retrieving geolocation:'
            puts e.to_s
            sleep(5)
            puts 'Retrying...'
            retry
          end
        end
      end
    end

    # TODO test if all are here = count distinct regions, country
  end
end