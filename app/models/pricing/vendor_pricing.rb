require 'mongoid'

require_relative 'tarif'

module Pricing
  class VendorPricing
    include Mongoid::Document
    include Mongoid::Attributes::Dynamic

    # fields
    field :name, type: String
    field :currency, type: String
    field :date, type: Date

    # relations
    embeds_many :tarif

    # validation
    validates :name, presence: true
    validates :currency, presence: true, inclusion: {in: %w[EUR USD GBP]}
    validates :date, presence: true
    validates :tarif, presence: true
  end
end
