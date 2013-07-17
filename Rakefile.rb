require 'rake'
require 'json'
require 'mongo'

include Mongo

mongo = {
	"hostname" => "localhost",
	"port" => 27017,
	"username" => "",
	"password" => "",
	"name" => "",
	"db" => "paas"
}

unless ENV['VCAP_SERVICES'].nil?
    env = JSON.parse(ENV['VCAP_SERVICES'])
    mongo = env['mongodb-1.8'][0]['credentials']
end

namespace :mongo do
		
    desc "Imports all or the specified JSON file to the Mongo collection(s)"
    task :import do
			Dir.glob("profiles#{File::SEPARATOR}*.json").each do |file_name|
			puts file_name
				client = MongoClient.new(mongo["hostname"], mongo["port"])
				db = client.db(mongo['db'])
				db.authenticate(mongo["username"], mongo["password"])
				col = db["vendors"]
				data = JSON.parse(File.read(file_name))
				
				col.save(data)
				end
		end
end

Rake::Task["mongo:import"].reenable
Rake::Task["mongo:import"].invoke