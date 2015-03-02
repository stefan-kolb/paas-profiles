require_relative '../../app/models/vendor/pricing'

FactoryGirl.define do
  factory :pricing, class: Profiles::Pricing do
    model 'fixed'
    period 'monthly'
  end
end
