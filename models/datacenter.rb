require 'mongoid'
require 'iso_country_codes'

class Datacenter
  include Mongoid::Document

  # properties
  field :continent, type: String
  field :country, type: String
  field :region, type: String
  field :provider, type: Array
  field :coordinates, :type => Array

  # validations
  validates :continent, inclusion: { in: %w(AF AS EU NA OC SA)}
  validate :country_codes, :if => Proc.new { !country.nil? && !country.empty? }

  def country_codes
    if IsoCountryCodes.find(country).nil?
      errors[:country] = '#{country} is not a valid ISO 3166-1 code'
    end
  end

  def to_s
    name = "#{region}"
    name << " (#{provider.join(',')})" unless provider.blank?
    name
  end

end