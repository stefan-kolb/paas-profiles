require 'json'
require 'mongoid'
require 'rake/testtask'
require 'active_support/core_ext'
require 'geocoder'
require 'rest-client'
require 'open-uri'
#require 'git'

require_relative 'models/vendor/vendor'
require_relative 'models/snapshot'
require_relative 'models/statistics'
#require_relative 'models/statistics/runtime_stats'
#require_relative 'models/statistics/data_trend'
require_relative 'models/statistics/runtime_trend'
require_relative 'models/datacenter'

Mongoid.load!('./config/mongoid.yml')

namespace :mongo do

  desc "Imports all PaaS JSON profiles to MongoDB"
  task :import do
    # delete collection
    Vendor.delete_all
    # import files
    Dir.glob("./profiles#{File::SEPARATOR}*.json").each do |file_name|
      begin
        data = JSON.parse(File.read(file_name))
        Vendor.create!(data)
      rescue Exception => e
        raise "An error occurred while parsing " + file_name + ": " + e.message
      end
    end
    # be sure everything was imported
    unless Dir["./profiles#{File::SEPARATOR}*.json"].length == Vendor.count
      raise "Not all profiles were imported into MongoDB"
    end
    # twitter data
    twitter
    # geo information
    geodata
  end

  def twitter
    data = JSON.parse(File.read('./data/twitter_profiles.json'))

    data.each do |e|
      unless e['twitter'].blank? || e['image'].blank?
        begin
          Vendor.find_by(name: e['vendor']).update(
              twitter: e['twitter'],
              image: e['image']
          )
        rescue Mongoid::Errors::DocumentNotFound
          # ignore
        end
      end
    end
  end

  def geodata
    # Raise errors
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
                  ds.provider = [ infra.provider ]
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

  desc "Creates a snapshot of all PaaS JSON profiles"
  task :snapshot do
    # stats
    # overall trends
    sum_languages = 0
    Vendor.all.each { |v| sum_languages += v.runtimes.count }
    mean = (sum_languages / Vendor.count.to_f).round(1)

    Statistics.create(
        revision: Time.now.utc + 4.days,
        vendor_count: Vendor.count,
        mean_lang_count: mean,
        polyglot_count: Vendor.count - Vendor.where(:runtimes.with_size => 1).count,
        lspecific_count: Vendor.where(:runtimes.with_size => 1).count,
        language_count: Vendor.distinct('runtimes.language').count
    )
    # runtime trend
    Vendor.distinct('runtimes.language').each do |l|
      RuntimeTrend.create!(
          revision: Time.now.utc,
          language: l,
          count: Vendor.where('runtimes.language' => l).count,
          percentage: (Vendor.where('runtimes.language' => l).count / Vendor.count.to_f).round(2)
      )
    end
    # snapshot
    Snapshot.create!(
        revision: Time.now.utc + 4.days,
        vendors: Vendor.all
    )
  end
end

namespace :profiles do

  desc "Sorts all entries in the profiles"
  task :sort do
    # import files
    Dir.glob("./profiles#{File::SEPARATOR}/**/*.json").each do |file_name|
      begin
        data = JSON.parse(File.read(file_name))
        # sort
        data['runtimes'].sort_by! { |r| r['language'] } unless data['runtimes'].blank?
        data['middleware'].sort_by! { |m| m['name'] } unless data['middleware'].blank?
        data['frameworks'].sort_by! { |f| f['name'] } unless data['frameworks'].blank?
        unless data['services'].blank?
          data['services']['native'].sort_by! { |n| n['name'] } unless data['services']['native'].blank?
          data['services']['addon'].sort_by! { |a| a['name'] } unless data['services']['addon'].blank?
        end
        data['infrastructures'].sort_by! { |c| c['continent'] } unless data['infrastructures'].blank?
        # save file
        File.open(file_name, "w") do |f|
          f.write(JSON.pretty_generate(data))
        end
      rescue
        raise "An error occurred while sorting #{file_name}"
      end
    end
  end

  desc "Retrieves profile pictures from Twitter"
  task :images do
    data = JSON.parse(File.read('./data/twitter_profiles.json'))

    data.each do |e|
      unless e['twitter'].blank?
        begin
          # FIXME limit is 180
          resp = RestClient.get("https://api.twitter.com/1.1/users/show.json?screen_name=#{e['twitter']}", :'authorization' => "Bearer #{ENV['TWITTER_SECRET']}")
          unless resp.code == 200
            fail "Bad response"
          end

          profile = JSON.parse(resp.body)
          img_url = profile['profile_image_url_https'].gsub('normal', 'bigger')
          e['image'] = img_url

          # TODO delete files
          fn = e['vendor'].downcase.gsub(/[^a-z0-9]/, '_') << File.extname(img_url)
          open('public/img/vendor/' << fn, 'wb') do |file|
            file.write(open(e['image']).read)
          end
        rescue Exception => ex
          puts "Error retrieving image of #{e['vendor']}"
          puts ex.message
          puts "Rate limiting is 15 minutes!"
        end
      end
    end

    File.open('./data/twitter_profiles.json', 'w') do |f|
      f.write(JSON.pretty_generate data)
    end
  end
end

Rake::TestTask.new do |t|
  t.warning = true
  t.verbose = true
  t.test_files = FileList['test/test*.rb']
end

task :default => [:test]
