require_relative '../../app/models/vendor/runtime'

FactoryGirl.define do
  factory :runtime do
    sequence(:language) { |n| "language#{n}" }
  end
end