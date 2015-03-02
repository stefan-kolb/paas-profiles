require_relative '../../app/models/vendor/scaling'

FactoryGirl.define do
  factory :scaling, class: Profiles::Scaling do
    vertical false
    horizontal true
    auto false
  end
end
