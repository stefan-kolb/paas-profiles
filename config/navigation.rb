SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :index, 'PaaS Profiles', '/vendors' do |index|
      index.item :vendor, @paas, @route
      index.item :filter, 'Find your PaaS', '/filter'
      index.item :compare, '1on1', '/compare'
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