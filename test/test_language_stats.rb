require 'minitest/autorun'
require 'json'
require 'active_support/core_ext'
require 'mongoid'
require 'factory_girl'

require_relative '../models/vendor'
require_relative '../lib/statistics/language_charts'

Mongoid.load!('config/mongoid.yml', :test)
FactoryGirl.find_definitions

class TestLanguageStats < MiniTest::Unit::TestCase
      include FactoryGirl::Syntax::Methods

      # deletes all collections and indexes before each test
      def setup
        Mongoid.purge!
      end

      def test_language_count
        # single vendor
        create(:vendor)
        chart = LanguageCharts.new
        assert_equal(1, chart.language_count, 'Unexpected amount of distinct runtime languages')
        # multiple vendors
        create_list(:vendor, 10)
        chart = LanguageCharts.new
        assert_equal(1, chart.language_count, 'Unexpected amount of distinct runtime languages')
      end

      def test_mean_count
        create_list(:vendor, 10)
        assert(Vendor.count == 10, 'Vendor.count should be 10. Database was not set up correctly.')

      end

      def test_mode_count
        create_list(:vendor, 10)
        assert(Vendor.count == 10, 'Vendor.count should be 10. Database was not set up correctly.')

      end

      def test_median_count
        create_list(:vendor, 10)
        assert(Vendor.count == 10, 'Vendor.count should be 10. Database was not set up correctly.')

      end

      def test_support_data
        create_list(:vendor, 10)
        assert(Vendor.count == 10, 'Vendor.count should be 10. Database was not set up correctly.')
      end

      def test_support_categories
        create_list(:vendor, 10)
        assert(Vendor.count == 10, 'Vendor.count should be 10. Database was not set up correctly.')
      end

      #
      def test_language_support
        # 100% ruby support
        create_list(:vendor_with_runtimes, 10, runtime: 'ruby')
        chart = LanguageCharts.new
        data = JSON.parse(chart.support_columndata)

        assert_equal(1, data.size, 'Unexpected amount of distinct runtime languages')
        assert_equal('ruby', data.first['name'].downcase, 'Unexpected runtime language name')
        assert_equal(100, data.first['y'], 'Unexpected language support percentage')

        # 25 % language support
        create_list(:vendor_with_runtimes, 10, runtime: 'java')
        create_list(:vendor_with_runtimes, 10, runtime: 'php')
        create_list(:vendor_with_runtimes, 10, runtime: 'node')

        chart = LanguageCharts.new
        data = JSON.parse(chart.support_columndata)
        assert_equal(4, data.size, 'Unexpected amount of distinct runtime languages')
        data.each do |d|
          assert_equal(25, d['y'], 'Unexpected language support percentage')
        end
      end

      def test_language_support_default_threshold
        create_list(:vendor_with_runtimes, 96, runtime: 'ruby')
        create_list(:vendor_with_runtimes, 2, runtime: 'java')
        create_list(:vendor_with_runtimes, 2, runtime: 'php')

        # 5% threshold
        chart = LanguageCharts.new
        data = JSON.parse(chart.support_columndata)

        # < 5% should be grouped as Others
        assert_equal(2, data.size, 'Unexpected amount of distinct runtime languages')
        assert_equal(96, data[0]['y'], 'Unexpected language support percentage')
        assert_equal('ruby', data[0]['name'].downcase, 'Unexpected runtime language name')
        assert_equal('others', data[1]['name'].downcase, 'Unexpected runtime language name')
        assert_equal(4, data[1]['y'], 'Unexpected language support percentage')
      end

      def test_language_support_custom_threshold
        create_list(:vendor_with_runtimes, 91, runtime: 'ruby')
        create_list(:vendor_with_runtimes, 5, runtime: 'java')
        create_list(:vendor_with_runtimes, 4, runtime: 'php')

        # 10% threshold
        chart = LanguageCharts.new
        data = JSON.parse(chart.support_columndata 0.1)

        # < 10% should be grouped as Others
        assert_equal(2, data.size, 'Unexpected amount of distinct runtime languages')
        assert_equal(91, data[0]['y'], 'Unexpected language support percentage')
        assert_equal('ruby', data[0]['name'].downcase, 'Unexpected runtime language name')
        assert_equal('others', data[1]['name'].downcase, 'Unexpected runtime language name')
        assert_equal(9, data[1]['y'], 'Unexpected language support percentage')
      end

end