source 'https://rubygems.org'

ruby File.read('.ruby-version').strip

gem 'activesupport'
gem 'geocoder'
gem 'grape', '~> 1.4.0'
gem 'grape-entity', '~> 0.8.1'
gem 'iso_country_codes'
gem 'mongo', '~> 2.8.0'
gem 'mongoid', '~> 6.0'
gem 'rake'
gem 'require_all'
gem 'rest-client'
gem 'rmagick', '~> 5.3'
gem 'rss'
gem 'rubocop', require: false
gem 'sinatra', '~> 2.1'
gem 'sinatra-simple-navigation', '~> 4.0'
gem 'versionomy'

group :test do
  gem 'database_cleaner'
  gem 'factory_bot'
  gem 'minitest'
  gem 'rack-test'
  gem 'shoulda-context'
end

group :production do
  gem 'unicorn'
end
