require 'minitest/autorun'
require 'json'
require 'active_support/core_ext'

require_relative '../models/vendor/vendor'

Mongoid.load!('../config/mongoid.yml', :test)

class TestConsistency < MiniTest::Test
  def setup
    Vendor.delete_all

    Dir.glob('../profiles/*.json').each do |file|
      begin
        data = JSON.parse(File.read(file))
        Vendor.create!(data)
      rescue Exception => e
        raise "An error occurred while parsing #{file}: #{e.message}"
      end
    end
  end

  def teardown
    Vendor.delete_all
  end

  # only one distinct runtime allowed per framework
  def test_framework_runtimes
    find_duplicates :frameworks
  end

  # only one distinct runtime allowed per middleware
  def test_middleware_runtimes
    find_duplicates :middleware
  end

  # TODO distinct url per add-on

  private

  def find_duplicates(field)
    distinct = Vendor.distinct("#{field}.name")
    products = Vendor.all.pluck(field).flatten

    distinct.each do |f|
      product = products.select { |e| e['name'].eql?(f) }
      uniq_runtimes = product.uniq { |e| e['runtime'] }
      assert_equal(1, uniq_runtimes.size, "The #{field} #{f} must only be defined by one distinct runtime. Found: #{uniq_runtimes.collect { |e| e['runtime'] }.join(',')}")
    end
  end

end