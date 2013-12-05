SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :index, 'PaaS Profiles', '/vendors' do |index|
      index.item :vendor, @paas, @route
      index.item :filter, 'Find your PaaS', '/filter'
    end
  end
end