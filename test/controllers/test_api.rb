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

  def test_get_unknown_vendor_returns_not_found
    get '/api/vendors/this_vendor_is_unknown'
    assert(last_response.not_found?, 'This vendor should be unknown')
  end

  def test_get_vendor_returns_vendor
    vendor = create(:vendor)
    entity = Profiles::Vendor::Entity.represent(vendor)
    get "/api/vendors/#{vendor.name}"
    assert(last_response.ok?)
    assert_equal(last_response.body, entity.to_json, 'Unexpected JSON response')
  end

  def test_get_vendor_expects_string_parameter
    get '/api/vendors/alphanumeric_and_underscore_only_no_1+23'
    assert(last_response.client_error?, 'No [a-z_] parameters should raise 4xx client error')
  end
end
