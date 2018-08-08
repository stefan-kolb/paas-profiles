require_relative '../test_helper'

class TestApi < MiniTest::Test
  include Rack::Test::Methods
  include FactoryBot::Syntax::Methods

  def app
    APPLICATION
  end

  def setup
    @vendor = create(:vendor)
  end

  def teardown
    DatabaseCleaner.clean
  end

  context 'GET vendor' do
    should 'return an existing vendor' do
      entity = Profiles::Vendor::Entity.represent(@vendor)
      get "/api/vendors/#{@vendor.name}"
      assert(last_response.ok?)
      assert_equal(entity.to_json, last_response.body, 'Unexpected JSON response')
    end

    should 'return not found for nonexistant vendor' do
      get '/api/vendors/this_vendor_is_unknown'
      assert(last_response.not_found?, 'This vendor should be unknown')
    end

    should 'should only accept string parameters' do
      get '/api/vendors/alphanumeric_and_underscore_only_no_1+23'
      assert(last_response.client_error?, 'No [a-z_] parameters should raise 4xx client error')
    end
  end

  context 'POST broker' do
    should 'return client error when request body is missing' do
      post '/api/broker'
      assert(last_response.client_error?)
    end

    should 'return all vendors when query is empty' do
      entities = [Profiles::Vendor::Entity.represent(@vendor)]
      post '/api/broker', '{}'
      assert(last_response.ok?)
      assert_equal(entities.to_json, last_response.body, 'Unexpected JSON response')
    end
  end

  context 'GET infrastructures' do
    should 'return infrastructures' do
      get '/api/infrastructures'
      assert(last_response.ok?)
      # TODO: test factory
    end

    should 'query external geo API when location is unknown' do
      vendor = create(:vendor)
      response = [{ latLng: [49.8926723,10.8876149], name: 'Bamberg' }]
      get "/api/vendors/#{vendor.name}/infrastructures"
      assert(last_response.ok?)
      assert_equal(response.to_json, last_response.body, 'Unexpected JSON response')
    end

    should 'unescape vendor name correctly' do
      create(:vendor, name: 'OpenShift Online')

      url_name = 'openshift%20online'
      get "/api/vendors/#{url_name}/infrastructures"
      assert(last_response.ok?)

      url_name = 'openshift+online'
      get "/api/vendors/#{url_name}/infrastructures"
      assert(last_response.ok?)
    end
  end
end
