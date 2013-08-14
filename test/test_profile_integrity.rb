gem 'minitest', '>= 5.0'

require 'json'
require 'minitest/autorun'

require_relative '../models/vendor'

class TestProfileIntegrity < Minitest::Test
	# create a test for every profile
	Dir.glob(File.dirname(__FILE__) + '/../profiles/*.json') do |file|
		testname = File.basename(file, ".json")
		
		define_method("test_#{testname}_profile") do
			profile = nil
			# wellformedness
			begin
				profile = JSON.parse(File.read(file))
			rescue JSON::ParserError  
				assert(profile != nil, "JSON structure is not wellformed")
			end
			
			# name must match filename removing spaces dashes etc
			
			# profile validation
			obj = Vendor.new(profile)
			assert(obj.valid?, obj.errors.full_messages) # todo get embedded messages
		end
	end
end