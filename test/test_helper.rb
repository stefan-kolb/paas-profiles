ENV['RACK_ENV'] = 'test'

require 'factory_girl'
require 'require_all'
require 'database_cleaner'
require 'mongoid'
require 'minitest/autorun'
require 'rack/test'
require 'shoulda/context'
require 'rest-client'

# database
Mongoid.load!('config/mongoid.yml')
Mongo::Logger.logger.level = ::Logger::INFO
# fixtures
FactoryGirl.find_definitions
# TODO: not always needed!
# models
require_all 'app/models'
# TODO: not always needed!
# entities
require_all 'app/entities'
# TODO: deprecation warnings, remove with active support 5
ActiveSupport::TestCase.test_order = :random

APPLICATION = Rack::Builder.parse_file(__dir__ << '/../config.ru').first
