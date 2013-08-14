gem 'minitest', '>= 5.0'

require 'json'
require 'minitest/autorun'
require 'date'

class TestProfileIntegrity < Minitest::Test
	# create a test for every profile
	Dir.glob(File.dirname(__FILE__) + '/../profiles/*.json') do |file|
		testname = File.basename(file, ".json")
		
		define_method("test_#{testname}_profile") do
			profile = {}
			# wellformedness
			begin
				profile = JSON.parse(File.read(file))
			rescue JSON::ParserError  
				assert(profile != nil, "JSON structure is not wellformed")
			end
			
			# mandatory properties
			refute_nil(profile["name"], "Property 'name' must be present")
			refute_nil(profile["url"], "Property 'url' must be present")
			refute_nil(profile["status"], "Property 'status' must be present")
			refute_nil(profile["hosting"], "Property 'hosting' must be present")
			refute_nil(profile["pricing"], "Property 'pricing' must be present")
			refute_nil(profile["scaling"], "Property 'scaling' must be present")
			refute_nil(profile["compliance"], "Property 'compliance' must be present")
			refute_nil(profile["runtimes"], "Property 'runtimes' must be present")
			refute_nil(profile.has_key?("middleware"), "Property 'middleware' must be present")
			refute_nil(profile.has_key?("frameworks"), "Property 'frameworks' must be present")
			refute_nil(profile.has_key?("services"), "Property 'services' must be present")
			refute_nil(profile["extendable"], "Property 'extendable' must be present")
			refute_nil(profile["infrastructures"], "Property 'infrastructures' must be present")
			# name must match filename removing spaces dashes etc
			# vendor verified true or false
			assert(profile["vendor_verified"] == true || profile["vendor_verified"] == false, "Property 'vendor_verified' must be a Boolean")
			# url
			assert_match(/http[s]?:\/\/.*/, profile["url"], "URL format is not valid")
			# status production or beta
			assert(profile["status"] == "production" || profile["status"] == "beta", "Status must be 'production' or 'beta'")
			# status since datetime
			# assert_instance_of(DateTime, DateTime.parse(profile["status_since"]), "Property 'status_since' must be a valid Date or DateTime")
			# type free
			# hosting public private
			assert(valid_hosting_options?(profile), "Hosting options must be either 'public' or 'private'")		
			# pricing model fixed,metered hybrid period daily monthly anually
			# scaling vertical horizontal auto
			# compliance free
			# runtimes 
			# middleware
			# frameworks
			# services
			# native
			# addons
			# extendable boolean
			# infrastructure
			profile["infrastructures"].each do |i|
				# continent
				assert(["AS", "NA", "SA", "EU", "OC", "AF"].include?(i["continent"]), "Infrastructure 'continent' must be a valid continent code")
				# country
				unless i["country"].empty?
					assert(valid_country_code?(i["country"]), "Infrastructure 'country' must be a valid ISO-3166-2 code")
				end
			end
			# region free
			# provider optional
		end
	end
	
	def valid_hosting_options? profile
		profile["hosting"].each do |h|
			unless h == "public" || h == "private"
				return false
			end
		end
				
		true
	end

	def valid_country_code? code
		codes = JSON.parse(File.read(File.dirname(__FILE__) + "/../public/js/iso-3166-2.json"))
		
		unless codes.any? {|c| c["alpha-2"] == code}
				return false
		end
				
		true	
	end

end