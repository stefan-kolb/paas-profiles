require_relative '../test_helper'

class TestMain < Minitest::Test
  include Rack::Test::Methods
  include FactoryBot::Syntax::Methods

  def app
    APPLICATION
  end

  def setup
    create(:vendor)
  end

  def teardown
    DatabaseCleaner.clean
  end

  context 'Webapp' do
    should 'show a vendor overview page' do
      get '/vendors'
      assert(last_response.ok?)
    end

    should 'show detailed vendor pages' do
      vendor = create(:vendor, name: 'Heroku')
      get "/vendors/#{vendor.name}"
      assert(last_response.ok?)
      assert(last_response.body.include?('Heroku'), 'Unexpected response body')
    end

    should 'show a broker page' do
      get '/filter'
      assert(last_response.ok?)
    end

    should 'show a default comparison page' do
      create(:vendor, name: 'Heroku')
      create(:vendor, name: 'Openshift Online')
      get '/compare'
      assert(last_response.ok?)
    end

    should 'show an overview statistics page' do
      get '/statistics'
      assert(last_response.ok?)
    end

    should 'show a runtime statistics page' do
      get '/statistics/languages'
      assert(last_response.ok?)
    end

    should 'show an infrastructure statistics page' do
      create(:vendor_with_infrastructures)
      get '/statistics/infrastructures'
      assert(last_response.ok?)
    end
  end
end
