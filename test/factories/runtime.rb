require_relative '../../models/runtime'

FactoryGirl.define do
  factory :runtime do
    sequence(:language) { |n| "language#{n}" }
  end
end