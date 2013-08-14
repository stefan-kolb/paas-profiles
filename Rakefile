require 'json'
require 'mongoid'
require 'rake/testtask'

require_relative 'models/vendor'

Mongoid.load!("./config/mongoid.yml", :production)

namespace :mongo do
		
    desc "Imports all PaaS JSON profiles to MongoDB"
    task :import do
			# delete collection
			Vendor.delete_all
				
			Dir.glob("profiles#{File::SEPARATOR}*.json").each do |file_name|
				data = JSON.parse(File.read(file_name))
				Vendor.create(data)
			end
		end
end

Rake::TestTask.new do |t|
		t.warning = true
		t.verbose = true
		t.test_files = FileList['test/test*.rb']
end

task :default => [:test]