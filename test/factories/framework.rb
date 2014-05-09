require_relative '../../models/vendor/framework'

FactoryGirl.define do
  factory :framework do
    name 'rails'
    runtime 'ruby'
  end
end