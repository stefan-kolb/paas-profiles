require 'json'
require 'active_support'
require 'active_support/core_ext'

require_relative '../test_helper'
require_relative '../../app/models/vendor/vendor'

module Profiles
  # create a test class for every profile
  Dir.glob(File.join(__dir__, '..', '..', 'profiles/*.json')) do |file|
    # filename
    filename = File.basename(file, '.json')

    # test class
    test_class = Class.new(MiniTest::Test) do
      # set file path
      @file_path = file
      # profile
      @profile = nil

      class << self
        attr_reader :file_path
      end

      # loads and validates profile
      def setup
        begin
          json = JSON.parse(File.read(self.class.file_path))
          @profile = Vendor.new(json)
        rescue JSON::ParserError
          refute_nil(@profile, 'JSON structure is not well-formed')
        end

        # profile validation
        assert(@profile.valid?, @profile.errors.full_messages)
      end

      def teardown
        @profile = nil
      end

      # filename must match lowercase vendor name after replacing [^a-z0-9] with '_'
      define_method('test_filename') do
        exp_name = @profile['name'].downcase.gsub(/[^a-z0-9]/, '_')
        assert_equal(exp_name, filename, 'Filename must match lowercase vendor name without all characters except a-z0-9 replaced by "_"')
      end

      # url must be reachable
      define_method('test_url') do
        begin
          RestClient::Request.execute(method: :get, url: @profile['url'], timeout: 10)
        rescue StandardError
          $stderr.puts "WARN: #{@profile['name']} URL must respond with status 200 (OK)"
        end
      end

      # must be available either as public or private service
      define_method('test_hosting_existence') do
        assert(@profile.hosting.public || @profile.hosting.private || @profile.hosting.vps, 'A PaaS must be available either as public, virtual private or private service')
      end

      # no runtime (language) duplicates
      define_method('test_runtime_duplicates') do
        uniq_runtimes = @profile.runtimes.uniq { |item| item['language'] }

        assert_equal(uniq_runtimes.length, @profile.runtimes.length, 'There must be no duplicate runtime entries in one profile. Merge them into one entity')
      end

      # no middleware (name) duplicates
      define_method('test_middleware_duplicates') do
        uniq_middleware = @profile.middlewares.uniq { |item| item['name'] }

        assert_equal(uniq_middleware.length, @profile.middlewares.length, 'There must be no duplicate middleware entries in one profile. Merge them into one entity')
      end

      # no framework (name) duplicates
      define_method('test_frameworks_duplicates') do
        uniq_frameworks = @profile.frameworks.uniq { |item| item['name'] }

        assert_equal(uniq_frameworks.length, @profile.frameworks.length, 'There must be no duplicate framework entries in one profile. Merge them into one entity')
      end

      # no native services (name) duplicates
      define_method('test_native_services_duplicates') do
        unless @profile.service.blank? || @profile.service.natives.blank?
          uniq_services = @profile.service.natives.uniq { |item| item['name'] }

          assert_equal(uniq_services.length, @profile.service.natives.length, 'There must be no duplicate native services entries in one profile. Merge them into one entity')
        end
      end

      # no add-on services (name) duplicates
      define_method('test_addon_services_duplicates') do
        unless @profile.service.blank? || @profile.service.addons.blank?
          uniq_services = @profile.service.addons.uniq { |item| item['name'] }

          assert_equal(uniq_services.length, @profile.service.addons.length, 'There must be no duplicate add-on services entries in one profile. Merge them into one entity')
        end
      end

      # no compliance duplicates
      define_method('test_compliance_duplicates') do
        unless @profile.quality.blank? || @profile.quality.compliance.blank?
          uniq_compliance = @profile.quality.compliance.uniq

          assert_equal(uniq_compliance.length, @profile.quality.compliance.length, 'There must be no duplicate compliance entries in one profile. Remove duplicate values')
        end
      end

      # middleware runtime must be present
      define_method('test_middleware_runtime_existence') do
        @profile.middlewares.each do |m|
          unless m['runtime'].blank?
            assert(@profile.runtimes.any? { |r| r['language'] == m['runtime'] }, "Referenced middleware runtime '#{m['runtime']}' of '#{m['name']}' must be defined under runtimes")
          end
        end
      end

      # framework runtime must be present
      define_method('test_frameworks_runtime_existence') do
        @profile.frameworks.each do |f|
          assert(@profile.runtimes.any? { |r| r['language'] == f['runtime'] }, "Referenced framework runtime '#{f['runtime']}' of '#{f['name']}' must be defined under runtimes")
        end
      end

      # TODO: real version formats, for now: versions array must not include empty version strings
      define_method('test_version_formats') do
        # runtimes
        @profile.runtimes.each do |r|
          break if r.versions.nil?
          refute(r.versions.any?(&:empty?), 'Runtime versions must not include empty version strings')
        end
        # middleware
        @profile.middlewares.each do |m|
          break if m.versions.nil?
          refute(m.versions.any?(&:empty?), 'Middleware versions must not include empty version strings')
        end
        # frameworks
        @profile.frameworks.each do |f|
          break if f.versions.nil?
          refute(f.versions.any?(&:empty?), 'Framework versions must not include empty version strings')
        end
        # native services
        unless @profile.service.blank? || @profile.service.natives.blank?
          @profile.service.natives.each do |s|
            break if s.versions.nil?
            refute(s.versions.any?(&:empty?), 'Native service versions must not include empty version strings')
          end
        end
      end

      # TODO: superset versions
      # no runtime version duplicates and overlaps
      define_method('test_version_duplicates') do
        # runtimes
        @profile.runtimes.each do |r|
          break if r.versions.nil?

          uniq_versions = r.versions.uniq
          assert_equal(uniq_versions.length, r.versions.length, 'There must be no duplicate runtime versions. This includes versions overlapped by a version superset')
        end
        # middleware
        @profile.middlewares.each do |m|
          break if m.versions.nil?

          uniq_versions = m.versions.uniq
          assert_equal(uniq_versions.length, m.versions.length, 'There must be no duplicate middleware versions. This includes versions overlapped by a version superset')
        end
        # frameworks
        @profile.frameworks.each do |f|
          break if f.versions.nil?

          uniq_versions = f.versions.uniq
          assert_equal(uniq_versions.length, f.versions.length, 'There must be no duplicate framework versions. This includes versions overlapped by a version superset')
        end
        # native services
        unless @profile.service.blank? || @profile.service.natives.blank?
          @profile.service.natives.each do |s|
            break if s.versions.nil?

            uniq_versions = s.versions.uniq
            assert_equal(uniq_versions.length, s.versions.length, 'There must be no duplicate native service versions. This includes versions overlapped by a version superset')
          end
        end
      end
    end

    # self-descriptive classname
    const_set("Test#{filename.split('_').map(&:capitalize).join('_')}", test_class)
  end
end
