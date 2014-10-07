require_relative '../../app/models/vendor/framework'

FactoryGirl.define do
  factory :framework do
    name 'rails'
    runtime 'ruby'
  end
end