require 'mongoid'
require 'iso_country_codes'

class Infrastructure
  include Mongoid::Document

  # profile properties
  field :continent, type: String
  field :country, type: String
  field :region, type: String
  field :provider, type: String

  # validations
  validates :continent, presence: true, inclusion: {in: %w(AF AS EU NA OC SA)}
  validates :country, presence: true, :if => Proc.new { !region.blank? }
  validate :country_codes, :if => Proc.new { !country.blank? }

  def country_codes
    if IsoCountryCodes.find(country).nil?
      errors[:country] = '#{country} is not a valid ISO 3166-1 code'
    end
  end

end