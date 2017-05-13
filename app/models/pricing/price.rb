require 'mongoid'

module Pricing
  class Price
    include Mongoid::Document
    include Mongoid::Attributes::Dynamic

    embedded_in :parameter

    # fields
    field :minimum, type: Integer
    field :pricing_unit, type: String
    field :price_per_unit, type: Float

    # validations
    validates :minimum, presence: true
    validates :pricing_unit, presence: true
    validates :price_per_unit, presence: false
  end
end
