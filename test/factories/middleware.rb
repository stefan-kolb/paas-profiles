require_relative '../../app/models/vendor/middleware'

FactoryGirl.define do
  factory :middleware, class: Profiles::Middleware do
    name 'tomcat'
  end
end
