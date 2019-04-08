require_relative '../../app/models/vendor/pricing'

FactoryBot.define do
  factory :pricing, class: Profiles::Pricing do
    model { 'fixed' }
    period { 'monthly' }
  end
end
