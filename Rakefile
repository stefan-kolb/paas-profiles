require 'json'
require 'mongoid'

require_relative 'models/vendor'

Mongoid.load!("mongoid.yml", :production)

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