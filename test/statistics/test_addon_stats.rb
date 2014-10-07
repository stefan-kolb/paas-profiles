require 'minitest/autorun'
require 'json'
require 'active_support/core_ext'
require 'mongoid'
require 'factory_girl'

require_relative '../../app/models/vendor/vendor'
require_relative '../../lib/statistics/language_charts'

Mongoid.load!('config/mongoid.yml', :test)

class TestAddonStats < MiniTest::Test
      include FactoryGirl::Syntax::Methods

      # deletes all collections and indexes before each test
      def setup
        Mongoid.purge!
      end

end