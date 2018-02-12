require 'json'
require 'active_support/core_ext'

require_relative '../../app/models/vendor/vendor'
require_relative '../../lib/statistics/language_charts'

module Profiles
  class TestLanguageStats < MiniTest::Test
    include FactoryBot::Syntax::Methods

    def teardown
      DatabaseCleaner.clean
    end

    def test_language_count
      # test aggregation
      create_list(:vendor, 10, language: 'ruby')
      # test counting
      create_list(:vendor_with_distinct_runtimes, 10, runtime_count: 2)
      chart = LanguageCharts.new
      assert_equal(21, chart.language_count, 'Unexpected amount of distinct runtime languages')
    end

    def test_mean_count
      create_list(:vendor_with_distinct_runtimes, 5, runtime_count: 5)
      create_list(:vendor_with_distinct_runtimes, 5, runtime_count: 10)
      chart = LanguageCharts.new
      # (5*5+5*10)/10
      assert_equal(7.5, chart.mean_count, 'Unexpected mean language count')
    end

    def test_mode_count
      # unimodal
      create_list(:vendor, 5, language: 'ruby')
      chart = LanguageCharts.new
      # 1,1,1,1,1
      assert_equal([1], chart.mode_count, 'Unexpected mode language count')
      # multimodal
      create_list(:vendor_with_distinct_runtimes, 5, runtime_count: 3)
      chart = LanguageCharts.new
      # 1,1,1,1,1,3,3,3,3,3
      assert_equal([1, 3], chart.mode_count, 'Unexpected mode language count')
    end

    def test_median_count
      # odd number
      create_list(:vendor_with_distinct_runtimes, 1, runtime_count: 1)
      create_list(:vendor_with_distinct_runtimes, 1, runtime_count: 2)
      create_list(:vendor_with_distinct_runtimes, 1, runtime_count: 3)
      chart = LanguageCharts.new
      # 1,2,3
      assert_equal(2, chart.median_count, 'Unexpected median language count')
      # even number
      create_list(:vendor_with_distinct_runtimes, 1, runtime_count: 4)
      chart = LanguageCharts.new
      # 1,2,3,4
      assert_equal(2.5, chart.median_count, 'Unexpected median language count')
    end
=begin
      # TODO ab hier
      def test_support_data
        create_list(:vendor, 10)
        assert(Vendor.count == 10, 'Vendor.count should be 10. Database was not set up correctly.')
      end

      def test_support_categories
        create_list(:vendor, 10)
        assert(Vendor.count == 10, 'Vendor.count should be 10. Database was not set up correctly.')
      end

      #
      def test_language_support_no_threshold
        # 100% ruby support
        create_list(:vendor_with_runtimes, 10, runtime: 'ruby')
        chart = LanguageCharts.new
        data = JSON.parse(chart.support_columndata 0)

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
=end
  end
end
