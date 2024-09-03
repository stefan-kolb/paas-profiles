require 'json'
require 'active_support'
require 'active_support/core_ext'

require_relative '../test_helper'
require_relative '../../app/models/vendor/vendor'

module Profiles
  class TestDuplicates < Minitest::Test
    def setup
      Dir.glob(File.join(__dir__, '..', '..', 'profiles/*.json')).each do |file|
        begin
          data = JSON.parse(File.read(file))
          Vendor.create!(data)
        rescue StandardError => e
          raise "An error occurred while parsing #{file}: #{e.message}"
        end
      end
    end

    def teardown
      DatabaseCleaner.clean
    end

    def test_middleware
      find_duplicates :middlewares
    end

    def test_frameworks
      find_duplicates :frameworks
    end

    def test_services
      find_duplicates :'services.native'
    end

    def test_addons
      find_duplicates :'services.addon'
    end

    private

    def find_duplicates(field)
      Vendor.distinct("#{field}.name").each do |e|
        partial = Vendor.where("#{field}.name" => /^#{e}/i)
        exact = Vendor.where("#{field}.name" => /^#{e}$/i)

        if partial.size != exact.size
          vendors = partial - exact
          warn "WARN: Potential duplicate #{field} of #{e} found @ vendors #{vendors.collect!(&:name).to_a.join(',')}"
        end
      end
    end
  end
end
