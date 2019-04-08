require_relative '../../app/models/vendor/scaling'

FactoryBot.define do
  factory :scaling, class: Profiles::Scaling do
    vertical { false }
    horizontal { true }
    auto { false }
  end
end
