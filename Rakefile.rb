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
		
    desc "Imports all or the specified JSON file to the Mongo collection(s)"
    task :import do
		
			client = MongoClient.new(mongo["hostname"], mongo["port"])
			db = client.db(mongo['db'])
			unless mongo["hostname"] == "localhost"
				db.authenticate(mongo["username"], mongo["password"])
			end
			col = db["vendors"]
			
			Dir.glob("profiles#{File::SEPARATOR}*.json").each do |file_name|

				data = JSON.parse(File.read(file_name))
				
				if col.stats()["count"] > 0
					if col.find({ name: data["name"] }).limit(1).count() > 0
						col.update({"name" => data["name"]}, data)
					else
						col.save(data)
					end
				else
					col.save(data)
				end
			end
		end
end

Rake::Task["mongo:import"].invoke