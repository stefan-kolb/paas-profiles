require 'mongoid'
require 'iso_country_codes'

module Profiles
  class Datacenter
    include Mongoid::Document

    # properties
    field :continent, type: String
    field :country, type: String
    field :region, type: String
    field :provider, type: Array
    field :coordinates, type: Array

    # validations
    validates :continent, inclusion: { in: %w[AF AS EU NA OC SA] }
    validate :country_codes, if: proc { !country.nil? && !country.empty? }

    def country_codes
      code = IsoCountryCodes.find(country)
      errors[:country] = "#{country} is not a valid ISO 3166-1 code" if code.nil?
    end

    def to_s
      name = region.to_s
      name << " (#{provider.join(',')})" unless provider.blank?
      name
    end
  end
end
