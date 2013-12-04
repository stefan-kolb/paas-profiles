require 'json'
require 'mongoid'
require 'rake/testtask'
require 'active_support/core_ext'

require_relative 'models/vendor'
require_relative 'models/snapshot'
require_relative 'models/statistics'
require_relative 'models/statistics/runtime_trend'

Mongoid.load!("./config/mongoid.yml")

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
        rescue
          raise "An error occurred while parsing " + file_name + ".json"
        end
      end
      # be sure everything was imported
      unless Dir["./profiles#{File::SEPARATOR}*.json"].length == Vendor.count
        raise "Not all profiles were imported into MongoDB"
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
end

Rake::TestTask.new do |t|
		t.warning = true
		t.verbose = true
		t.test_files = FileList['test/test*.rb']
end

task :default => [:test]