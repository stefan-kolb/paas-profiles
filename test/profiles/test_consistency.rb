require 'json'
require 'active_support'
require 'active_support/core_ext'

require_relative '../test_helper'
require_relative '../../app/models/vendor/vendor'

module Profiles
  class TestConsistency < MiniTest::Test
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

    # do only allow a limited set of runtimes for now
    def test_runtime_names
      runtimes = %w[apex clojure cobol docker dotnet erlang go groovy haskell hhvm java lua node perl php python ruby scala swift xsjs]

      Vendor.all.each do |v|
        v[:runtimes].each do |rt|
          runtime = rt[:language]
          assert(runtimes.include?(runtime), "Runtime not allowed: #{runtime}. Should be one of: #{runtimes.join(',')}")
        end
      end
    end

    # do not allow to have one software in any of the other categories
    def test_software_intersection
      software = %w[runtimes.language middlewares.name frameworks.name services.native.name services.addon.name]
      arr = []
      software.each do |s|
        arr << Vendor.distinct(s)
      end

      arr.each_with_index do |s, i|
        temp = arr.dup
        temp.delete_at(i)

        s.each do |entry|
          refute(temp.flatten.include?(entry), "Intersecting software #{entry}. No software entity may be included in another category.")
        end
      end
    end

    # only one distinct runtime allowed per framework
    def test_framework_runtimes
      distinct_runtime :frameworks
    end

    # only one distinct runtime allowed per middleware
    def test_middleware_runtimes
      distinct_runtime :middlewares
    end

    # TODO: distinct url per add-on

    private

    def distinct_runtime(field)
      distinct = Vendor.distinct("#{field}.name")
      products = Vendor.all.pluck(field).flatten.compact

      distinct.each do |f|
        product = products.select { |e| e['name'].eql?(f) }
        uniq_runtimes = product.uniq { |e| e['runtime'] }
        assert_equal(1, uniq_runtimes.size, "The #{field} #{f} must only be defined by one distinct runtime. Found: #{uniq_runtimes.collect { |e| e['runtime'] }.join(',')}")
      end
    end
  end
end
