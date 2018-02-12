require_relative '../../app/models/vendor/framework'

FactoryBot.define do
  factory :framework, class: Profiles::Framework do
    name 'rails'
    runtime 'ruby'
  end
end
