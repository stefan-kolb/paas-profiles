require_relative '../test_helper'

class TestVendor < Minitest::Test
  include FactoryBot::Syntax::Methods

  def setup
    @json = JSON.parse(File.read(__dir__ + '/../fixtures/vendor.json'))
  end

  should 'parse JSON profile correctly' do
    entity = Profiles::Vendor.new(@json)

    # fields
    assert_equal('example', entity.name)
    assert_equal('http://www.example.com', entity.url)
    assert_equal('production', entity.status)
    assert_equal('example', entity.type)
    assert_equal(true, entity.extensible)
    # dates
    assert_equal(Date.new(1970).year, entity.revision.year)
    assert_equal(Date.new(1970).year, entity.vendor_verified.year)
    assert_equal(Date.new(1970).year, entity.status_since.year)
    # objects
    refute_nil(entity.hosting)
    assert_equal(true, entity.hosting.public)
    assert_equal(true, entity.hosting.private)

    refute_nil(entity.scaling)
    assert_equal(true, entity.scaling.horizontal)
    assert_equal(true, entity.scaling.vertical)
    assert_equal(true, entity.scaling.auto)

    refute_nil(entity.quality)
    assert_equal(100, entity.quality.uptime)
    assert_equal('example', entity.quality.compliance.first)

    refute_nil(entity.pricings)
    assert_equal('fixed', entity.pricings.first.model)
    assert_equal('monthly', entity.pricings.first.period)

    refute_nil(entity.runtimes)
    assert_equal('example', entity.runtimes.first.language)
    assert_equal('1.0', entity.runtimes.first.versions.first)

    refute_nil(entity.middlewares)
    assert_equal('example', entity.middlewares.first.name)
    assert_equal('example', entity.middlewares.first.runtime)
    assert_equal('1.0', entity.middlewares.first.versions.first)

    refute_nil(entity.frameworks)
    assert_equal('example', entity.frameworks.first.name)
    assert_equal('example', entity.frameworks.first.runtime)
    assert_equal('1.0', entity.frameworks.first.versions.first)

    refute_nil(entity.service)

    refute_nil(entity.service.natives)
    assert_equal('example', entity.service.natives.first.name)
    assert_equal('1.0', entity.service.natives.first.versions.first)
    assert_equal('example', entity.service.natives.first.type)

    refute_nil(entity.service.addons)
    assert_equal('example', entity.service.addons.first.name)
    assert_equal('http://www.example.com', entity.service.addons.first.url)
    assert_equal('example', entity.service.addons.first.description)
    assert_equal('example', entity.service.addons.first.type)

    refute_nil(entity.infrastructures)
    assert_equal('EU', entity.infrastructures.first.continent)
    assert_equal('DE', entity.infrastructures.first.country)
    assert_equal('example', entity.infrastructures.first.region)
    assert_equal('example', entity.infrastructures.first.provider)
  end
end
