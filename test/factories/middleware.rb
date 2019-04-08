require_relative '../../app/models/vendor/middleware'

FactoryBot.define do
  factory :middleware, class: Profiles::Middleware do
    name { 'tomcat' }
  end
end
