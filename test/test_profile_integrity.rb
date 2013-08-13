gem 'minitest', '>= 5.0'
require 'json'
require 'minitest/autorun'

class TestProfileIntegrity < Minitest::Test
	# create a test for every profile
	Dir.glob('profiles/*.json') do |file|
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
			#assert_instance_of(TrueClass || FalseClass, profile["vendor_verified"], "")
			# url
			assert_match(/http[s]?:\/\/.*/, profile["url"], "URL format is not valid")
			# status production or beta
			assert(profile["status"] == "production" || profile["status"] == "beta", "Status must be 'production' or 'beta'")
			# status since datetime
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
			# infrastructure continent
			# country iso
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

=begin
	def valid_country_code? profile
		profile["infrastructures"].each do |i|
			unless i["country"]
				return false
			end
		end
				
		true	
	end
=end

end