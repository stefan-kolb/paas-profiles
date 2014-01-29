require_relative '../../models/pricing'

FactoryGirl.define do
  factory :pricing do
    model 'fixed'
    period 'monthly'
  end
end