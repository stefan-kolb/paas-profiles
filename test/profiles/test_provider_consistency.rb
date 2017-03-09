require 'json'
require 'active_support'
require 'active_support/core_ext'

require_relative '../test_helper'
require_relative '../../app/models/vendor/vendor'

module Profiles
  class TestProviderConsistency < MiniTest::Test
    def setup
      Dir.glob(File.join(__dir__, '..', '..', 'profiles/*.json')).each do |file|
        begin
          data = JSON.parse(File.read(file))
          Vendor.create!(data)
        rescue StandardError => e
          raise "An error occurred while parsing #{file}: #{e.message}"
        end
      end

      @providers = Vendor.in(platform: Vendor.distinct(:platform))
    end

    def teardown
      @providers = nil
      DatabaseCleaner.clean
    end

    # horizontal & vertical scaling capabilities should be identical
    def test_scaling_capabilities
      loop_providers do |provider, platform|
        assert_equal(platform.scaling.vertical, provider.scaling.vertical, "Vertical scaling capabilities for #{provider.name} differs to base platform #{platform.name}")
        assert_equal(platform.scaling.horizontal, provider.scaling.horizontal, "Horizontal scaling capabilities for #{provider.name} differs to base platform #{platform.name}")
      end
    end

    def test_extensibility
      loop_providers do |provider, platform|
        assert_equal(platform.extensible, provider.extensible, "Extensibility of #{provider.name} differs to base platform #{platform.name}")
      end
    end

    # provider should at least support the default runtimes of the platform
    def test_runtime_capabilities
      loop_providers do |provider, platform|
        platform.runtimes.each do |runtime|
          $stderr.puts "WARN: #{provider.name} does not support default runtime #{runtime.language} of base platform #{platform.name}" unless provider.runtimes.any? { |r| r.language.eql? runtime.language }
        end
      end
    end

    # provider should at least support the default middleware of the platform
    def test_middleware_capabilities
      loop_providers do |provider, platform|
        platform.middlewares.each do |mw|
          $stderr.puts "WARN: #{provider.name} does not support default middleware #{mw.name} of base platform #{platform.name}" unless provider.middlewares.any? { |m| m.name.eql? mw.name }
        end
      end
    end

    # provider should at least support the default frameworks of the platform
    def test_frameworks_capabilities
      loop_providers do |provider, platform|
        platform.frameworks.each do |fw|
          $stderr.puts "WARN: #{provider.name} does not support default framework #{fw.name} of base platform #{platform.name}" unless provider.frameworks.any? { |f| f.name.eql? fw.name }
        end
      end
    end

    # provider should at least support the default services of the platform
    def test_services_capabilities
      loop_providers do |provider, platform|
        platform.service.natives.each do |s|
          $stderr.puts "WARN: #{provider.name} does not support default service #{s.name} of base platform #{platform.name}" unless provider.service.natives.any? { |r| r.name.eql? s.name }
        end
      end
    end

    private

    def loop_providers
      @providers.each do |p|
        provider = p
        platform = Vendor.find_by(name: p['platform'])

        yield provider, platform
      end
    end
  end
end
