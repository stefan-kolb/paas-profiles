ENV['RACK_ENV'] = 'test'

require 'factory_girl'
require 'require_all'
require 'database_cleaner'
require 'mongoid'
require 'minitest/autorun'
require 'rack/test'
require 'shoulda/context'

# database
Mongoid.load!('./config/mongoid.yml')
# fixtures
FactoryGirl.find_definitions
# TODO: not always needed!
# models
require_all 'app/models'
# TODO: not always needed!
# entities
require_all 'app/entities'

APPLICATION = Rack::Builder.parse_file(__dir__ << '/../config.ru').first
