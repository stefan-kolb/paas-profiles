require 'minitest/autorun'
require 'rack/test'

require_relative '../test_helper'

class TestApi < MiniTest::Test
  include Rack::Test::Methods
  include FactoryGirl::Syntax::Methods

  def app
    APPLICATION
  end

  def setup
    create(:vendor)
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_it_returns_vendors
    get '/vendors'
    assert(last_response.ok?)
  end

  def test_it_returns_a_vendor
    vendor = create(:vendor, name: 'Heroku')
    get "/vendors/#{vendor.name}"
    assert(last_response.ok?)
    assert(last_response.body.include?('Heroku'), 'Unexpected response body')
  end

  def test_it_has_a_broker
    get '/filter'
    assert(last_response.ok?)
  end

  def test_it_has_a_default_comparison
    create(:vendor, name: 'Heroku')
    create(:vendor, name: 'Pivotal Web Services')
    get '/compare'
    assert(last_response.ok?)
  end

  def test_it_has_statistics
    get '/statistics'
    assert(last_response.ok?)
  end

  def test_it_has_runtime_statistics
    get '/statistics/languages'
    assert(last_response.ok?)
  end

  def test_it_has_infrastructure_statistics
    create(:vendor_with_infrastructures)
    get '/statistics/infrastructures'
    assert(last_response.ok?)
  end
end
