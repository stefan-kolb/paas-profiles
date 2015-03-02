require_relative '../../app/models/vendor/infrastructure'

FactoryGirl.define do
  factory :infrastructure, class: Profiles::Infrastructure do
    continent 'EU'
    country 'DE'
    region 'Bamberg'

    trait :provider do
      provider 'Amazon Web Services'
    end
  end
end
