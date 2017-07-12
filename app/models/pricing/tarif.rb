require 'mongoid'

require_relative 'parameter'

module Pricing
  class Tarif
    include Mongoid::Document
    include Mongoid::Attributes::Dynamic

    embedded_in :vendorPricing

    # fields
    field :name, type: String
    field :interval, type: String

    # relations
    embeds_many :parameter

    # validations
    validates :interval, presence: true
    validates :interval, presence: true, inclusion: { in: %w[daily monthly annually] }
    validates :parameter, presence: true
  end
end
