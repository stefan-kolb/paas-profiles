require_relative '../app/models/snapshot'
require_relative '../app/models/statistics'
# require_relative '../app/models/statistics/runtime_stats'
# require_relative '../app/models/statistics/data_trend'
require_relative '../app/models/statistics/runtime_trend'
# require_relative '../app/models/software/addon'
# require_relative '../app/models/software/service'
# require_relative '../app/models/software/framework'
# require_relative '../app/models/software/middleware'
require_relative '../app/models/datacenter'
require_relative '../app/models/service_vendor'

namespace :db do

  desc 'Imports all existing vendor profiles'
  task :seed do
    # delete collection
    Profiles::Vendor.delete_all
    # import files
    Dir.glob('profiles/*.json').each do |file|
      begin
        data = JSON.parse(File.read(file))
        Profiles::Vendor.create!(data)
      rescue StandardError => e
        raise "An error occurred while parsing #{file}: #{e.message}"
      end
    end
    # be sure everything was imported
    unless Dir['profiles/*.json'].length == Profiles::Vendor.count
      fail 'Not all profiles were imported!'
    end
    # geographical information
    datacenter
    # technology information
    technologies
    # service vendors
    service_vendors
  end

  def service_vendors
    data = JSON.parse(File.read('./data/service_vendors.json'))

    # delete collection
    Profiles::ServiceVendor.delete_all
    data.each do |e|
      begin
        Profiles::ServiceVendor.create!(e)
      rescue StandardError => e
        raise "An error occurred while writing service vendors: #{e.message}"
      end
    end
  end

  def technologies
    data = JSON.parse(File.read('./data/technologies.json'))

    data.each do |e|
      begin
        Profiles::Vendor.find_by(name: e['vendor']).update(
          platform: e['platform'],
          isolation: e['isolation'],
          dev_model: e['dev_model']
        )
      rescue Mongoid::Errors::DocumentNotFound
        puts "WARN: Vendor #{e} is missing for technology update"
      end
    end
  end

  def twitter
    data = JSON.parse(File.read('./data/twitter_profiles.json'))

    data.each do |e|
      next if e['twitter'].blank?

      begin
        Profiles::Vendor.find_by(name: e['vendor']).update(
          twitter: e['twitter']
        )
      rescue Mongoid::Errors::DocumentNotFound
        puts 'WARN: Vendor is missing for twitter update'
      end

    end
  end

  def datacenter
    Profiles::Datacenter.delete_all

    data = JSON.parse(File.read('./data/geo_datacenter.json'))

    data.each do |dc|
      begin
        Profiles::Datacenter.create!(dc)
      rescue StandardError => e
        raise "An error occurred while writing datacenter #{dc}: #{e.message}"
      end
    end
  end

  desc 'Creates a snapshot of all PaaS JSON profiles'
  task :snapshot do
    # stats
    # overall trends
    sum_languages = 0
    Profiles::Vendor.all.each { |v| sum_languages += v.runtimes.count }
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

  task :history do
    g = Git.open('C:\Users\Administrator\Documents\GitHub\paas-profiles')

    g.log(500).since('30 weeks ago').each do |l|
      g.checkout l
      dir = 'C:/Users/Administrator/Documents/GitHub/paas-profiles/profiles/*'
      active = Dir[dir].count { |file| File.file?(file) }
      dir = 'C:/Users/Administrator/Documents/GitHub/paas-profiles/profiles/eol/*'
      eol = Dir[dir].count { |file| File.file?(file) }

      dt = DataTrend.new(
        revision: l.date,
        active_count: active,
        eol_count: eol
      )
      # only write if something has changed TODO?
      last = DataTrend.asc(:revision).last

      if last.nil? || last.active_count != dt.active_count || last.eol_count != dt.eol_count
        dt.save
      end

      # restore historic database
      # TODO: problem if test does not pass!
      begin
        # Rake::Task[:test].execute
        Rake::Task['mongo:import'].execute

        # Runtime trends
        new = RuntimeStats.new(
          revision: l.date,
          polyglot: Vendor.count - Vendor.where(:runtimes.with_size => 1).count,
          language_specific: Vendor.where(:runtimes.with_size => 1).count,
          distinct_languages: Vendor.distinct('runtimes.language').count
        )

        # only write if something has changed TODO?
        last = RuntimeStats.asc(:revision).last

        if last.nil? || last.polyglot != new.polyglot || last.language_specific != new.language_specific || last.distinct_languages != new.distinct_languages
          new.save
        end
      rescue StandardError => e
        puts e.message
      end
    end
    # checkout master again
    g.checkout
    # restore most recent database
    Rake::Task['mongo:import'].execute
  end

end
