require_relative '../../app/models/vendor/runtime'

FactoryBot.define do
  factory :runtime, class: Profiles::Runtime do
    sequence(:language) { |n| "language#{n}" }
  end
end
