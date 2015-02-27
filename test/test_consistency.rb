require 'minitest/autorun'
require 'json'
require 'active_support'
require 'active_support/core_ext'

require_relative 'test_helper'
require_relative '../app/models/vendor/vendor'

class TestConsistency < MiniTest::Test
  def setup
    Dir.glob(File.dirname(__FILE__) + '/../profiles/*.json').each do |file|
      begin
        data = JSON.parse(File.read(file))
        Vendor.create!(data)
      rescue Exception => e
        raise "An error occurred while parsing #{file}: #{e.message}"
      end
    end
  end

  def teardown
    DatabaseCleaner.clean
  end

  # do not allow to have one software in any of the other categories
  def test_software_intersection
    software = %w(runtimes.language middleware.name frameworks.name services.native.name services.addon.name)
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
    distinct_runtime :middleware
  end

  # TODO distinct url per add-on

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