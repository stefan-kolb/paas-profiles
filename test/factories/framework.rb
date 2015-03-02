require_relative '../../app/models/vendor/framework'

FactoryGirl.define do
  factory :framework, class: Profiles::Framework do
    name 'rails'
    runtime 'ruby'
  end
end
