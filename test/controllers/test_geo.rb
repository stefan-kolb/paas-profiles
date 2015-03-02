require 'minitest/autorun'
require 'rack/test'

require_relative '../test_helper'

class TestApi < MiniTest::Test
  include Rack::Test::Methods
  include FactoryGirl::Syntax::Methods

  def app
    APPLICATION
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_get_vendor_infrastructures_remote_query
    vendor = create(:vendor)
    response = [{ latLng: [49.8988135, 10.9027636], name: 'Bamberg' }]
    get "/vendors/#{vendor.name}/infrastructures"
    assert(last_response.ok?)
    assert_equal(response.to_json, last_response.body, 'Unexpected JSON response')
  end
end
