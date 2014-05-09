require_relative '../../models/vendor/hosting'

FactoryGirl.define do
  factory :hosting do
    # mandatory properties
    public true
    private false
  end
end