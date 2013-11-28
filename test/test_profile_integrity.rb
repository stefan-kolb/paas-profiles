gem 'minitest', '>= 5.0'

require 'json'
require 'minitest/autorun'
require 'active_support/core_ext'

require_relative '../models/vendor'

class TestProfileIntegrity < Minitest::Test
  attr_accessor :profile

  before do
    @profile = Person.new
  end

  after do
    @profile = nil
  end
	# create a test for every profile
	Dir.glob(File.dirname(__FILE__) + '/../profiles/*.json') do |file|
		filename = File.basename(file, ".json")
		
		define_method("test_#{filename}_profile") do
			profile = nil
			# wellformedness
			begin
				profile = JSON.parse(File.read(file))
			rescue JSON::ParserError  
				assert(profile != nil, "JSON structure is not wellformed")
			end
			
			# profile validation
			obj = Vendor.new(profile)
			assert(obj.valid?, obj.errors.full_messages) # todo get embedded messages
			# name must match filename removing spaces dashes etc
			exp_name = obj["name"].downcase.gsub(/[^a-z0-9]/, '_')
			assert_equal(exp_name, filename, "Filename must match lowercase vendor name without all characters except a-z0-9 replaced by '_'")
    end

    # no duplicates
    define_method("test_#{filename}_runtime_duplicates") do
      profile = nil
      # wellformedness
      begin
        profile = JSON.parse(File.read(file))
      rescue JSON::ParserError
        assert(profile != nil, "JSON structure is not wellformed")
      end

      # profile validation
      obj = Vendor.new(profile)
      # check for runtime (language) duplicates
      uniq_runtimes = obj.runtimes.uniq { |item| item['language'] }

      assert_equal(uniq_runtimes.length, obj.runtimes.length, "There must be no duplicate runtime entries in one profile. Merge them into one entity")
    end

    define_method("test_#{filename}_middleware_duplicates") do
      profile = nil
      # wellformedness
      begin
        profile = JSON.parse(File.read(file))
      rescue JSON::ParserError
        assert(profile != nil, "JSON structure is not wellformed")
      end

      # profile validation
      obj = Vendor.new(profile)
      # check for middleware (name) duplicates
      uniq_middleware = obj.middlewares.uniq { |item| item['name'] }

      assert_equal(uniq_middleware.length, obj.middlewares.length, "There must be no duplicate middleware entries in one profile. Merge them into one entity")
    end

    define_method("test_#{filename}_frameworks_duplicates") do
      profile = nil
      # wellformedness
      begin
        profile = JSON.parse(File.read(file))
      rescue JSON::ParserError
        assert(profile != nil, "JSON structure is not wellformed")
      end

      # profile validation
      obj = Vendor.new(profile)
      # check for frameworks (name) duplicates
      uniq_frameworks = obj.frameworks.uniq { |item| item['name'] }

      assert_equal(uniq_frameworks.length, obj.frameworks.length, "There must be no duplicate framework entries in one profile. Merge them into one entity")
    end

    define_method("test_#{filename}_native_services_duplicates") do
      profile = nil
      # wellformedness
      begin
        profile = JSON.parse(File.read(file))
      rescue JSON::ParserError
        assert(profile != nil, "JSON structure is not wellformed")
      end

      # profile validation
      obj = Vendor.new(profile)
      # check for native services (name) duplicates
      unless obj.service.blank? || obj.service.natives.blank?
        uniq_services = obj.service.natives.uniq { |item| item['name'] }

        assert_equal(uniq_services.length, obj.service.natives.length, "There must be no duplicate native services entries in one profile. Merge them into one entity")
      end
    end

    define_method("test_#{filename}_addon_services_duplicates") do
      profile = nil
      # wellformedness
      begin
        profile = JSON.parse(File.read(file))
      rescue JSON::ParserError
        assert(profile != nil, "JSON structure is not wellformed")
      end

      # profile validation
      obj = Vendor.new(profile)
      # check for add-on services (name) duplicates
      unless obj.service.blank? || obj.service.addons.blank?
        uniq_services = obj.service.addons.uniq { |item| item['name'] }

        assert_equal(uniq_services.length, obj.service.addons.length, "There must be no duplicate add-on services entries in one profile. Merge them into one entity")
      end
    end

    define_method("test_#{filename}_compliance_duplicates") do
      profile = nil
      # wellformedness
      begin
        profile = JSON.parse(File.read(file))
      rescue JSON::ParserError
        assert(profile != nil, "JSON structure is not wellformed")
      end

      # profile validation
      obj = Vendor.new(profile)
      # check for compliance duplicates
      uniq_compliance = obj.compliance.uniq

      assert_equal(uniq_compliance.length, obj.compliance.length, "There must be no duplicate compliance entries in one profile. Remove duplicate values")
    end

    define_method("test_#{filename}_hosting_duplicates") do
      profile = nil
      # wellformedness
      begin
        profile = JSON.parse(File.read(file))
      rescue JSON::ParserError
        assert(profile != nil, "JSON structure is not wellformed")
      end

      # profile validation
      obj = Vendor.new(profile)
      # check for hosting duplicates
      uniq_hosting = obj.hosting.uniq

      assert_equal(uniq_hosting.length, obj.hosting.length, "There must be no duplicate hosting entries in one profile. Remove duplicate values")
    end

    # TODO duplicate versions
	end
end