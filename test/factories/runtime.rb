require_relative '../../app/models/vendor/runtime'

FactoryGirl.define do
  factory :runtime, class: Profiles::Runtime do
    sequence(:language) { |n| "language#{n}" }
  end
end
