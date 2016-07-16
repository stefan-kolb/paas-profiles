SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :index, 'PaaSfinder', '/vendors' do |index|
      index.item :vendor, @paas, @vendor_path
      index.item :filter, 'Find your PaaS', '/filter'
      index.item :terms, 'Terms of service', '/terms'
      index.item :compare, '1on1', @versus_path
      index.item :statistics, 'Statistics', '/statistics' do |statistics|
        statistics.item :languages, 'Runtime Languages', '/statistics/languages'
        statistics.item :services, 'Native Services', '/statistics/services'
        statistics.item :status, 'Status', '/statistics/status'
        statistics.item :infrastructures, 'Infrastructures', '/statistics/infrastructures'
        statistics.item :data, 'Data Quality', '/statistics/data'
      end
    end
  end
end
