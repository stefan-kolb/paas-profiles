require 'rake'
require 'mongoid'

Mongoid.load!("mongoid.yml", :development)

namespace :mongo do
def db_name
      Mongoid.session.database.name
    end
 
    def db_connection_options
      host, port  = "localhost:27017"
      auths       = ""
 
      auth_string = auths.length > 0 ? "-u #{auths[0]["username"]} -p #{auths[0]["password"]}" : ""
      conn_string = "#{auth_string} --host #{host} --port #{port} -d #{db_name}"
      conn_string
    end
		
    desc "Imports all or the specified JSON file to the Mongo collection(s)"
    task :import, [:directory, :collection] do |task, args|
        Dir.glob("#{args[:directory]}#{File::SEPARATOR}*.json").each do |file_name|
          collection_name = file_name.split("\/").last.split(".")[0]
          cmd = "mongoimport  --host localhost:27017 -d paas -c #{args[:collection]} --type json --file #{file_name} --upsert --stopOnError"
          puts "Executing: #{cmd}"
          `#{cmd}`
      end
    end
end