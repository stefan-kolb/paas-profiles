require_relative '../../models/framework'

FactoryGirl.define do
  factory :framework do
    name 'rails'
    runtime 'ruby'
  end
end