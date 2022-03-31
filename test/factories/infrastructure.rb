require_relative '../../app/models/vendor/infrastructure'

FactoryBot.define do
  factory :infrastructure, class: Profiles::Infrastructure do
    continent { 'EU' }
    country { 'DE' }
    region { 'Bamberg, Germany' }

    trait :provider do
      provider { 'Amazon Web Services' }
    end
  end
end
