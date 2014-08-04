require_relative '../models/snapshot'
require_relative '../models/statistics'
#require_relative '../models/statistics/runtime_stats'
#require_relative '../models/statistics/data_trend'
require_relative '../models/statistics/runtime_trend'

namespace :db do

  desc 'Imports all existing vendor profiles'
  task :seed do
    # delete collection
    Vendor.delete_all
    # import files
    Dir.glob('profiles/*.json').each do |file|
      begin
        data = JSON.parse(File.read(file))
        Vendor.create!(data)
      rescue Exception => e
        raise "An error occurred while parsing #{file}: #{e.message}"
      end
    end
    # be sure everything was imported
    unless Dir['profiles/*.json'].length == Vendor.count
      raise 'Not all profiles were imported!'
    end
    # geographical information
    Rake::Task["geo:datacenter"].execute
  end

  def twitter
    data = JSON.parse(File.read('./data/twitter_profiles.json'))

    data.each do |e|
      unless e['twitter'].blank?
        begin
          Vendor.find_by(name: e['vendor']).update(
              twitter: e['twitter']
          )
        rescue Mongoid::Errors::DocumentNotFound
          # ignore
        end
      end
    end
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

  task :history do
    g = Git.open('C:\Users\Administrator\Documents\GitHub\paas-profiles')

    g.log(count=500).since('30 weeks ago').each do |l|
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
      # TODO problem if test does not pass!
      begin
        #Rake::Task[:test].execute
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
      rescue Exception => e
        puts e.message
      end
    end
    # checkout master again
    g.checkout
    # restore most recent database
    Rake::Task['mongo:import'].execute
  end

end