ENV['RACK_ENV'] = 'test'

require 'factory_girl'
require 'require_all'
require 'database_cleaner'
require 'mongoid'

# database
Mongoid.load!('./config/mongoid.yml')
# fixtures
FactoryGirl.find_definitions
# models
require_all 'app/models'
# entities
require_all 'app/entities'

APPLICATION = Rack::Builder.parse_file(__dir__ << '/../config.ru').first
