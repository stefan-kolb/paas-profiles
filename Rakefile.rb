require 'rake'
require 'json'
require 'mongo'
require 'uri'

include Mongo

mongo = {
	"hostname" => "localhost",
	"port" => 27017,
	"username" => "",
	"password" => "",
	"db" => "paas"
}

namespace :mongo do
		
    desc "Imports all of the specified JSON files to the Mongo collection"
    task :import do
			if ENV['MONGOHQ_URL'].nil?
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
			else
				db = get_connection

				col = db["vendors"]
				# delete collection
				col.remove()
				
				Dir.glob("profiles#{File::SEPARATOR}*.json").each do |file_name|

					data = JSON.parse(File.read(file_name))
					
					col.save(data)
				end				
			end
		end
end

def get_connection
  return @db_connection if @db_connection
  db = URI.parse(ENV['MONGOHQ_URL'])
  db_name = db.path.gsub(/^\//, '')
  @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
  @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
  @db_connection
end

Rake::Task["mongo:import"].invoke