require 'factory_girl'
require 'require_all'
require 'database_cleaner'
require 'mongoid'

# test database
Mongoid.load!('./config/mongoid.yml', :test)
# fixtures
FactoryGirl.find_definitions
# models
require_all 'app/models'
# entities
require_all 'app/entities'