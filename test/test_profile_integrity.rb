gem 'minitest', '>= 5.0'

require 'json'
require 'minitest/autorun'

require_relative '../models/vendor'

class TestProfileIntegrity < Minitest::Test
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
			assert_equal(exp_name, filename, "Filename must match lowercase vendor name without all characters except a-z0-9 replaced by _")
		end
	end
end