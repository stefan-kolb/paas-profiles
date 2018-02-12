require_relative '../../app/models/vendor/hosting'

FactoryBot.define do
  factory :hosting, class: Profiles::Hosting do
    # mandatory properties
    public true
    private false
  end
end
