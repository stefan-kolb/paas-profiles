gem 'minitest', '~> 4.7'
require 'json'
require 'minitest/autorun'
require 'active_support/core_ext'

require_relative '../models/vendor'

module PaasProfiles
# create a test for every profile
  Dir.glob(File.dirname(__FILE__) + '/../profiles/*.json') do |file|
    new_class = Class.new(MiniTest::Unit::TestCase) do
      @@file = file

      attr_accessor :profile

      def setup
        begin
          @profile = JSON.parse(File.read(@@file))
          # profile validation
          @profile = Vendor.new(profile)
          assert(profile.valid?, profile.errors.full_messages) # todo get embedded messages
        rescue JSON::ParserError
          assert(@profile != nil, "JSON structure is not wellformed")
        end
      end

      def teardown
        @profile = nil
      end

      define_method("test_filename") do
        # name must match filename removing spaces dashes etc
        filename = File.basename(@@file, ".json")
        exp_name = profile["name"].downcase.gsub(/[^a-z0-9]/, '_')
        assert_equal(exp_name, filename, "Filename must match lowercase vendor name without all characters except a-z0-9 replaced by '_'")
      end

      # no duplicates
      define_method("test_runtime_duplicates") do
        # check for runtime (language) duplicates
        uniq_runtimes = profile.runtimes.uniq { |item| item['language'] }

        assert_equal(uniq_runtimes.length, profile.runtimes.length, "There must be no duplicate runtime entries in one profile. Merge them into one entity")
      end

      define_method("test_middleware_duplicates") do
        # check for middleware (name) duplicates
        uniq_middleware = profile.middlewares.uniq { |item| item['name'] }

        assert_equal(uniq_middleware.length, profile.middlewares.length, "There must be no duplicate middleware entries in one profile. Merge them into one entity")
      end

      define_method("test_frameworks_duplicates") do
        # check for frameworks (name) duplicates
        uniq_frameworks = profile.frameworks.uniq { |item| item['name'] }

        assert_equal(uniq_frameworks.length, profile.frameworks.length, "There must be no duplicate framework entries in one profile. Merge them into one entity")
      end

      define_method("test_native_services_duplicates") do
        # check for native services (name) duplicates
        unless profile.service.blank? || profile.service.natives.blank?
          uniq_services = profile.service.natives.uniq { |item| item['name'] }

          assert_equal(uniq_services.length, profile.service.natives.length, "There must be no duplicate native services entries in one profile. Merge them into one entity")
        end
      end

      define_method("test_addon_services_duplicates") do
        # check for add-on services (name) duplicates
        unless profile.service.blank? || profile.service.addons.blank?
          uniq_services = profile.service.addons.uniq { |item| item['name'] }

          assert_equal(uniq_services.length, profile.service.addons.length, "There must be no duplicate add-on services entries in one profile. Merge them into one entity")
        end
      end

      define_method("test_compliance_duplicates") do
        # check for compliance duplicates
        uniq_compliance = profile.compliance.uniq

        assert_equal(uniq_compliance.length, profile.compliance.length, "There must be no duplicate compliance entries in one profile. Remove duplicate values")
      end

      define_method("test_hosting_duplicates") do
        # check for hosting duplicates
        uniq_hosting = profile.hosting.uniq

        assert_equal(uniq_hosting.length, profile.hosting.length, "There must be no duplicate hosting entries in one profile. Remove duplicate values")
      end

      # TODO duplicate versions
    end # classdef

    # self-descriptive classname
    filename = File.basename(file, ".json")
    self.const_set("Test#{filename.capitalize}", new_class)

  end # dir glob

end