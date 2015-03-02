require 'mongoid'
require 'iso_country_codes'

module Profiles
  class Infrastructure
    include Mongoid::Document

    # profile properties
    field :continent, type: String
    field :country, type: String
    field :region, type: String
    field :provider, type: String

    # validations
    validates :continent, presence: true, inclusion: { in: %w(AF AS EU NA OC SA) }
    validates :country, presence: true, if: proc { !region.blank? }
    validate :country_codes, if: proc { !country.blank? }

    def country_codes
      code = IsoCountryCodes.find(country)
      # valid code
      errors[:country] = '#{country} is not a valid ISO 3166-1 code' if code.nil?
      # valid continent
      errors[:country] = 'Wrong continent code for #{country}' unless code.continent.eql?(continent)
    end
  end
end
