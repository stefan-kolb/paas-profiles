require 'minitest/autorun'
require 'rack/test'

require_relative '../test_helper'
require_relative '../../app/controllers/api'

class TestApi < MiniTest::Test
  include Rack::Test::Methods
  include FactoryGirl::Syntax::Methods

  def app
    Profiles::API
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_get_unknown_vendor_returns_not_found
    get '/api/vendors/this_vendor_is_unknown'
    assert(last_response.not_found?, 'Response status code should be 404')
  end

  def test_get_vendor_returns_vendor
    vendor = create(:vendor)
    get "/api/vendors/#{vendor.name}"
    assert(last_response.ok?, 'Response status code should be 200')
    assert_equal(last_response.body, Profiles::Vendor::Entity.represent(vendor).to_json)
  end

  def test_get_vendor_expects_string_parameter
    get '/api/vendors/alphanumeric_and_underscore_only_no_1+23'
    assert(last_response.client_error?, 'Response status code should be 4xx')
  end
end
