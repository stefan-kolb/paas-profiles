require 'rake'
require 'json'
require 'mongo'

include Mongo

mongo = {
	"hostname" => "localhost",
	"port" => 27017,
	"username" => "",
	"password" => "",
	"db" => "paas"
}

unless ENV['VCAP_SERVICES'].nil?
    env = JSON.parse(ENV['VCAP_SERVICES'])
    mongo = env['mongodb-1.8'][0]['credentials']
end

namespace :mongo do
		
    desc "Imports all of the specified JSON files to the Mongo collection"
    task :import do
		
			client = MongoClient.new(mongo["hostname"], mongo["port"])
			db = client.db(mongo['db'])
			unless mongo["hostname"] == "localhost"
				db.authenticate(mongo["username"], mongo["password"])
			end
			col = db["vendors"]
			# delete collection
			col.remove()
			
			Dir.glob("profiles#{File::SEPARATOR}*.json").each do |file_name|

				data = JSON.parse(File.read(file_name))
				
				col.save(data)
			end
		end
end

Rake::Task["mongo:import"].invoke