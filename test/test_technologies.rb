require 'minitest/autorun'
require 'json'

module Profiles
  class TestTechnologies < MiniTest::Test
    # for every vendor, technology data must be available
    def test_vendor_technologies
      profile_dir = File.join(__dir__, '..', 'profiles', '*.json')
      technologies = JSON.parse(File.read(File.join(__dir__, '..', 'data', 'technologies.json')))

      Dir.glob(profile_dir) do |file|
        vendor = File.basename(file, '.json').gsub('_', ' ')

        assert(technologies.detect { |t| t['vendor'].casecmp(vendor) }, "No technology data available for #{vendor}")
      end
    end
  end
end
