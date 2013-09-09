require 'json'
require 'mongoid'
require 'rake/testtask'

require_relative 'models/vendor'

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
end

Rake::TestTask.new do |t|
		t.warning = true
		t.verbose = true
		t.test_files = FileList['test/test*.rb']
end

task :default => [:test]